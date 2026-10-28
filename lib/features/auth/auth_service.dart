import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthFailure implements Exception {
  final String message;
  final int? status;
  final String? code;
  const AuthFailure(this.message, {this.status, this.code});
  @override
  String toString() => message;
}

abstract interface class SessionStorage {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  final FlutterSecureStorage storage;
  const SecureSessionStorage([this.storage = const FlutterSecureStorage()]);
  @override
  Future<String?> read() => storage.read(key: 'password_auth_session_v2');
  @override
  Future<void> write(String value) =>
      storage.write(key: 'password_auth_session_v2', value: value);
  @override
  Future<void> clear() async {
    await storage.delete(key: 'password_auth_session_v2');
    await storage.delete(key: 'password_auth_session_v1');
  }
}

class AuthUser {
  final String id;
  final String userId;
  final String name;
  final Map<String, dynamic> profile;
  bool get profileCompleted => profile['profileCompleted'] == true;
  String get phone =>
      profile['mobile'] as String? ?? profile['phone'] as String? ?? '';
  String? get email => profile['email'] as String?;
  AuthUser.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      userId = json['userId'] as String,
      name = json['name'] as String,
      profile = Map.unmodifiable(json);
}

class AuthService extends ChangeNotifier {
  static final instance = AuthService();
  static String get defaultBaseUrl {
    const configured = String.fromEnvironment(
      'AUTH_API_URL',
      defaultValue: String.fromEnvironment('FARMER_API_URL'),
    );
    if (configured.isNotEmpty)
      return configured.replaceFirst(RegExp(r'/+$'), '');
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080/api'
        : 'http://127.0.0.1:8080/api';
  }

  final http.Client _client;
  final SessionStorage _storage;
  final String baseUrl;
  AuthService({http.Client? client, SessionStorage? storage, String? baseUrl})
    : _client = client ?? http.Client(),
      _storage = storage ?? const SecureSessionStorage(),
      baseUrl = baseUrl ?? defaultBaseUrl;
  AuthUser? user;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessExpiresAt;
  DateTime? _refreshExpiresAt;
  String? restoreError;
  Future<void> Function()? onExpired;
  Future<void>? _refreshing;
  int _epoch = 0;
  Future<void> _storageWrites = Future.value();
  bool _expiring = false;
  bool get signedIn =>
      user != null &&
      _accessToken != null &&
      _refreshToken != null &&
      _refreshExpiresAt != null;
  Map<String, String> get authorizationHeaders => {
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<Map<String, dynamic>> _send(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    try {
      final request = http.Request(method, Uri.parse('$baseUrl$path'));
      request.headers['Content-Type'] = 'application/json';
      if (accessToken != null)
        request.headers['Authorization'] = 'Bearer $accessToken';
      if (body != null) request.body = jsonEncode(body);
      final response = await http.Response.fromStream(
        await _client.send(request).timeout(const Duration(seconds: 15)),
      ).timeout(const Duration(seconds: 15));
      Map<String, dynamic> data = {};
      if (response.body.isNotEmpty) {
        try {
          data =
              jsonDecode(utf8.decode(response.bodyBytes))
                  as Map<String, dynamic>;
        } on Object {
          throw const AuthFailure(
            'Server से सही response नहीं मिला। API URL जांचें।',
          );
        }
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AuthFailure(
          data['message'] as String? ??
              'Request पूरी नहीं हुई। फिर कोशिश करें।',
          status: response.statusCode,
          code: data['code'] as String?,
        );
      }
      return data;
    } on AuthFailure {
      rethrow;
    } on TimeoutException {
      throw const AuthFailure(
        'Server से जवाब नहीं मिला। Internet और backend जांचें।',
      );
    } on http.ClientException {
      throw const AuthFailure(
        'Backend से connection नहीं हुआ। Server चालू करें और API URL जांचें।',
      );
    } on Object {
      throw const AuthFailure('सेवा से connection नहीं हुआ। फिर कोशिश करें।');
    }
  }

  Future<void> _queueStorage(Future<void> Function() action) {
    final operation = _storageWrites.then((_) => action());
    _storageWrites = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return operation;
  }

  Future<void> _accept(Map<String, dynamic> data, {int? expectedEpoch}) async {
    final access = data['accessToken'];
    final refresh = data['refreshToken'];
    if (access is! String ||
        access.isEmpty ||
        refresh is! String ||
        refresh.isEmpty)
      throw const AuthFailure('Server ने सही access/refresh token नहीं दिए।');
    final nextUser = AuthUser.fromJson(Map<String, dynamic>.from(data['user']));
    final accessExpiry = DateTime.parse(
      data['accessTokenExpiresAt'] as String,
    ).toUtc();
    final refreshExpiry = DateTime.parse(
      data['refreshTokenExpiresAt'] as String,
    ).toUtc();
    if (expectedEpoch != null && expectedEpoch != _epoch)
      throw const AuthFailure('Session बदल गया है।', code: 'SESSION_CHANGED');
    await _queueStorage(() async {
      if (expectedEpoch != null && expectedEpoch != _epoch)
        throw const AuthFailure('Session बदल गया है।', code: 'SESSION_CHANGED');
      await _storage.write(
        jsonEncode({
          'accessToken': access,
          'refreshToken': refresh,
          'accessTokenExpiresAt': accessExpiry.toIso8601String(),
          'refreshTokenExpiresAt': refreshExpiry.toIso8601String(),
        }),
      );
    });
    if (expectedEpoch != null && expectedEpoch != _epoch)
      throw const AuthFailure('Session बदल गया है।', code: 'SESSION_CHANGED');
    _accessToken = access;
    _refreshToken = refresh;
    _accessExpiresAt = accessExpiry;
    _refreshExpiresAt = refreshExpiry;
    user = nextUser;
    restoreError = null;
    notifyListeners();
  }

  static String normalizeMobile(String value) {
    var number = value.trim().replaceAll(RegExp(r'[\s()-]'), '');
    if (number.startsWith('+91')) {
      number = number.substring(3);
    } else if (number.length == 12 && number.startsWith('91')) {
      number = number.substring(2);
    } else if (number.startsWith('0091')) {
      number = number.substring(4);
    }
    return number;
  }

  Future<void> register({
    required String mobile,
    required String password,
    required String confirmPassword,
    required String name,
    String email = '',
  }) async {
    final epoch = ++_epoch;
    final data = await _send(
      '/auth/register',
      method: 'POST',
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'mobile': normalizeMobile(mobile),
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    await _accept(data, expectedEpoch: epoch);
  }

  Future<void> login(String mobile, String password) async {
    final epoch = ++_epoch;
    final data = await _send(
      '/auth/login',
      method: 'POST',
      body: {'mobile': normalizeMobile(mobile), 'password': password},
    );
    await _accept(data, expectedEpoch: epoch);
  }

  Future<void> _expire(bool notifyExpiry) async {
    if (_expiring) return;
    _expiring = true;
    try {
      await _clear();
      if (notifyExpiry) await onExpired?.call();
    } finally {
      _expiring = false;
    }
  }

  /// All concurrent requests share one refresh, preventing accidental refresh-token reuse.
  Future<void> refreshSession({bool notifyExpiry = true}) async {
    final current = _refreshing;
    if (current != null) return current;
    final operation = _performRefresh(notifyExpiry);
    _refreshing = operation;
    try {
      await operation;
    } finally {
      if (identical(_refreshing, operation)) _refreshing = null;
    }
  }

  Future<void> _performRefresh(bool notifyExpiry) async {
    final epoch = _epoch;
    final token = _refreshToken;
    if (token == null) {
      await _expire(notifyExpiry);
      throw const AuthFailure('फिर login करें।', status: 401);
    }
    try {
      final data = await _send(
        '/auth/refresh',
        method: 'POST',
        body: {'refreshToken': token},
      );
      await _accept(data, expectedEpoch: epoch);
    } on AuthFailure catch (e) {
      if ((e.status == 401 || e.status == 403) && epoch == _epoch)
        await _expire(notifyExpiry);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _protected(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
    bool notifyExpiry = true,
  }) async {
    if (_accessExpiresAt != null &&
        !_accessExpiresAt!.isAfter(
          DateTime.now().toUtc().add(const Duration(seconds: 30)),
        )) {
      await refreshSession(notifyExpiry: notifyExpiry);
    }
    final usedToken = _accessToken;
    try {
      return await _send(
        path,
        method: method,
        body: body,
        accessToken: usedToken,
      );
    } on AuthFailure catch (e) {
      if (e.status != 401) rethrow;
      // A parallel request may already have rotated this access token.
      if (usedToken == _accessToken)
        await refreshSession(notifyExpiry: notifyExpiry);
      try {
        return await _send(
          path,
          method: method,
          body: body,
          accessToken: _accessToken,
        );
      } on AuthFailure catch (retryError) {
        if (retryError.status == 401) await _expire(notifyExpiry);
        rethrow;
      }
    }
  }

  Future<Map<String, String>> freshAuthorizationHeaders() async {
    if (_refreshToken != null &&
        _accessExpiresAt != null &&
        !_accessExpiresAt!.isAfter(
          DateTime.now().toUtc().add(const Duration(seconds: 30)),
        ))
      await refreshSession();
    return authorizationHeaders;
  }

  Future<bool> restore() async {
    restoreError = null;
    try {
      final raw = await _storage.read();
      if (raw == null) return false;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _accessToken = data['accessToken'] as String;
      _refreshToken = data['refreshToken'] as String;
      _accessExpiresAt = DateTime.parse(
        data['accessTokenExpiresAt'] as String,
      ).toUtc();
      _refreshExpiresAt = DateTime.parse(
        data['refreshTokenExpiresAt'] as String,
      ).toUtc();
      final profile = await _protected('/auth/me', notifyExpiry: false);
      user = AuthUser.fromJson(profile);
      notifyListeners();
      return true;
    } on AuthFailure catch (e) {
      user = null;
      if (e.status == 401 || e.status == 403) {
        await _clear();
        restoreError = 'Session समाप्त हो गया है। फिर login करें।';
      } else {
        restoreError = e.message;
      }
      notifyListeners();
      return false;
    } on Object {
      await _clear();
      restoreError = 'Saved session नहीं पढ़ सके। फिर login करें।';
      return false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profile) async {
    user = AuthUser.fromJson(
      await _protected('/users/me/profile', method: 'PUT', body: profile),
    );
    notifyListeners();
  }

  Future<void> _clear() async {
    ++_epoch;
    _accessToken = null;
    _refreshToken = null;
    _accessExpiresAt = null;
    _refreshExpiresAt = null;
    user = null;
    await _queueStorage(_storage.clear);
    notifyListeners();
  }

  Future<bool> logout() async {
    final token = _refreshToken;
    ++_epoch;
    bool revoked = true;
    try {
      if (token != null)
        await _send(
          '/auth/logout',
          method: 'POST',
          body: {'refreshToken': token},
        );
    } on AuthFailure catch (e) {
      revoked = e.status == 401;
    } finally {
      await _clear();
    }
    return revoked;
  }
}
