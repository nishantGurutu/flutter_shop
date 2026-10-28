import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/features/auth/auth_service.dart';
import 'package:shop/features/daily/daily_store.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'package:shop/view/unauthorised/login_screen.dart';

class MemorySession implements SessionStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    value = data;
  }

  @override
  Future<void> clear() async {
    value = null;
  }
}

class DelayedSession extends MemorySession {
  bool pause = false;
  final started = Completer<void>();
  final release = Completer<void>();
  @override
  Future<void> write(String data) async {
    if (pause) {
      started.complete();
      await release.future;
    }
    await super.write(data);
  }
}

Map<String, dynamic> userJson({
  String id = 'farmer-a',
  bool complete = false,
}) => {
  'id': id,
  'userId': 'ramesh',
  'name': 'Ramesh Patel',
  'phone': '9876543210',
  'mobile': '9876543210',
  'email': null,
  'village': complete ? 'Rampur' : '',
  'district': complete ? 'नीमच' : '',
  'state': 'मध्य प्रदेश',
  'language': 'हिंदी (Hindi)',
  'landArea': '',
  'selectedCrops': complete ? ['गेहूं (Wheat)'] : [],
  'profileCompleted': complete,
};
http.Response sessionResponse({bool complete = false}) => http.Response(
  jsonEncode({
    'accessToken': 'test-access',
    'refreshToken': 'test-refresh',
    'tokenType': 'Bearer',
    'accessTokenExpiresAt': '2030-01-01T00:00:00Z',
    'refreshTokenExpiresAt': '2030-02-01T00:00:00Z',
    'user': userJson(complete: complete),
  }),
  200,
  headers: {'content-type': 'application/json'},
);
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });
  test('register sends credentials, stores token but never password', () async {
    final storage = MemorySession();
    final auth = AuthService(
      storage: storage,
      baseUrl: 'http://test/api',
      client: MockClient((request) async {
        expect(request.url.path, '/api/auth/register');
        final body = jsonDecode(request.body);
        expect(body.containsKey('userId'), isFalse);
        expect(body['mobile'], '9876543210');
        expect(body['email'], 'farmer@example.com');
        expect(body['confirmPassword'], 'secret-pass-123');
        expect(body['password'], 'secret-pass-123');
        expect(body.containsKey('phone'), isFalse);
        return sessionResponse();
      }),
    );

    await auth.register(
      name: 'Ramesh Patel',
      email: 'farmer@example.com',
      mobile: '+91 98765 43210',
      password: 'secret-pass-123',
      confirmPassword: 'secret-pass-123',
    );
    expect(auth.signedIn, isTrue);
    expect(storage.value, contains('test-access'));
    expect(storage.value, isNot(contains('secret-pass')));
  });
  test(
    'wrong password and duplicate mobile preserve backend error codes',
    () async {
      for (final pair in [
        (401, 'INVALID_CREDENTIALS'),
        (409, 'MOBILE_ALREADY_REGISTERED'),
      ]) {
        final auth = AuthService(
          storage: MemorySession(),
          baseUrl: 'http://test/api',
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({'code': pair.$2, 'message': 'Try again'}),
              pair.$1,
            ),
          ),
        );
        await expectLater(
          auth.login('9876543210', 'wrong-pass'),
          throwsA(isA<AuthFailure>().having((e) => e.code, 'code', pair.$2)),
        );
        expect(auth.signedIn, isFalse);
      }
    },
  );
  test(
    'restore checks bearer token with server; revoked token is deleted',
    () async {
      final storage = MemorySession()
        ..value = jsonEncode({
          'accessToken': 'saved-access',
          'refreshToken': 'saved-refresh',
          'accessTokenExpiresAt': '2030-01-01T00:00:00Z',
          'refreshTokenExpiresAt': '2030-02-01T00:00:00Z',
        });
      final auth = AuthService(
        storage: storage,
        baseUrl: 'http://test/api',
        client: MockClient((r) async {
          expect(['/api/auth/me', '/api/auth/refresh'], contains(r.url.path));
          return http.Response(
            '{"code":"UNAUTHORIZED","message":"expired"}',
            401,
          );
        }),
      );
      expect(await auth.restore(), isFalse);
      expect(storage.value, isNull);
      expect(auth.user, isNull);
    },
  );
  test('temporary network failure keeps saved token for retry', () async {
    final storage = MemorySession()
      ..value = jsonEncode({
        'accessToken': 'saved-access',
        'refreshToken': 'saved-refresh',
        'accessTokenExpiresAt': '2030-01-01T00:00:00Z',
        'refreshTokenExpiresAt': '2030-02-01T00:00:00Z',
      });
    final auth = AuthService(
      storage: storage,
      baseUrl: 'http://test/api',
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    expect(await auth.restore(), isFalse);
    expect(storage.value, isNotNull);
    expect(auth.restoreError, isNotNull);
  });
  test('logout revokes server session and removes secure session', () async {
    final storage = MemorySession();
    final auth = AuthService(
      storage: storage,
      baseUrl: 'http://test/api',
      client: MockClient((r) async {
        if (r.url.path.endsWith('/login')) return sessionResponse();
        expect(r.url.path, '/api/auth/logout');
        expect(jsonDecode(r.body)['refreshToken'], 'test-refresh');
        return http.Response('', 204);
      }),
    );
    await auth.login('9876543210', 'secret-pass-123');
    expect(await auth.logout(), isTrue);
    expect(storage.value, isNull);
    expect(auth.signedIn, isFalse);
  });
  test('profile API returns updated user and completed state', () async {
    final auth = AuthService(
      storage: MemorySession(),
      baseUrl: 'http://test/api',
      client: MockClient((r) async {
        if (r.url.path.endsWith('/login')) return sessionResponse();
        expect(r.method, 'PUT');
        expect(r.url.path, '/api/users/me/profile');
        expect(r.headers['Authorization'], 'Bearer test-access');
        return http.Response(
          jsonEncode(userJson(complete: true)),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await auth.login('9876543210', 'secret-pass-123');
    await auth.updateProfile({'village': 'Rampur'});
    expect(auth.user!.profileCompleted, isTrue);
  });
  test('ledger and calendar stay isolated when switching accounts', () async {
    final farmer = FarmerProfileService();
    final daily = DailyStore.instance;
    await farmer.useAccount('a');
    await daily.useAccount('a');
    farmer.parseVoiceInput('बीज 750 रुपये');
    await farmer.flush();
    await daily.add(
      FarmTask(
        id: 15,
        title: 'Account A task',
        crop: 'Wheat',
        date: DateTime(2027, 1, 1),
      ),
    );
    await farmer.useAccount('b');
    await daily.useAccount('b');
    expect(farmer.khataEntries, isEmpty);
    expect(daily.tasks, isEmpty);
    await farmer.useAccount('a');
    await daily.useAccount('a');
    expect(farmer.khataEntries.single.amount, 750);
    expect(daily.tasks.single.title, 'Account A task');
    await farmer.useAccount(null);
    await daily.useAccount(null);
    expect(farmer.khataEntries, isEmpty);
    expect(daily.tasks, isEmpty);
  });
  testWidgets('login has mobile/password and no OTP or guest bypass', (
    tester,
  ) async {
    final auth = AuthService(
      storage: MemorySession(),
      client: MockClient((_) async => sessionResponse()),
    );
    await tester.pumpWidget(MaterialApp(home: LoginScreen(auth: auth)));
    expect(find.byKey(const Key('auth_mobile')), findsOneWidget);
    expect(find.byKey(const Key('auth_password')), findsOneWidget);
    expect(find.textContaining('OTP'), findsNothing);
    expect(find.textContaining('Guest'), findsNothing);
    expect(find.textContaining('User ID'), findsNothing);
    await tester.tap(find.byKey(const Key('auth_toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('auth_confirm')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();
    expect(find.text('सही मोबाइल नंबर लिखें'), findsOneWidget);
  });
  testWidgets('registration mismatch stays on form without API call', (
    tester,
  ) async {
    var calls = 0;
    final auth = AuthService(
      storage: MemorySession(),
      client: MockClient((_) async {
        calls++;
        return sessionResponse();
      }),
    );
    await tester.pumpWidget(MaterialApp(home: LoginScreen(auth: auth)));
    await tester.tap(find.byKey(const Key('auth_toggle')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('auth_name')), 'Test Farmer');
    await tester.enterText(find.byKey(const Key('auth_mobile')), '9876543210');
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'secret-pass-123',
    );
    await tester.enterText(
      find.byKey(const Key('auth_confirm')),
      'different-pass',
    );
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(find.text('दोनों passwords एक जैसे होने चाहिए'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('successful login opens home for completed profile', (
    tester,
  ) async {
    final auth = AuthService(
      storage: MemorySession(),
      client: MockClient((_) async => sessionResponse(complete: true)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(auth: auth, prepareAccount: (_) async {}),
        routes: {
          RoutesName.bottom_bar: (_) =>
              const Scaffold(body: Text('Signed in home')),
          RoutesName.profileSetup: (_) =>
              const Scaffold(body: Text('Profile setup')),
        },
      ),
    );
    await tester.enterText(find.byKey(const Key('auth_mobile')), '9876543210');
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'secret-pass-123',
    );
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Signed in home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test('expired access refreshes pair and retries protected request', () async {
    final storage = MemorySession();
    var refreshCalls = 0;
    var profileCalls = 0;
    final auth = AuthService(
      storage: storage,
      baseUrl: 'http://test/api',
      client: MockClient((r) async {
        if (r.url.path.endsWith('/login')) return sessionResponse();
        if (r.url.path.endsWith('/refresh')) {
          refreshCalls++;
          expect(jsonDecode(r.body)['refreshToken'], 'test-refresh');
          final result =
              jsonDecode(sessionResponse().body) as Map<String, dynamic>;
          result['accessToken'] = 'new-access';
          result['refreshToken'] = 'new-refresh';
          return http.Response(
            jsonEncode(result),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        profileCalls++;
        if (r.headers['Authorization'] == 'Bearer test-access')
          return http.Response('{"message":"expired"}', 401);
        expect(r.headers['Authorization'], 'Bearer new-access');
        return http.Response(
          jsonEncode(userJson(complete: true)),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await auth.login('9876543210', 'secret-pass-123');
    await auth.updateProfile({'village': 'Rampur'});
    expect(refreshCalls, 1);
    expect(profileCalls, 2);
    expect(storage.value, contains('new-refresh'));
    expect(storage.value, isNot(contains('test-refresh')));
  });
  test('parallel protected calls share one refresh operation', () async {
    var refreshCalls = 0;
    final auth = AuthService(
      storage: MemorySession(),
      baseUrl: 'http://test/api',
      client: MockClient((r) async {
        if (r.url.path.endsWith('/login')) return sessionResponse();
        if (r.url.path.endsWith('/refresh')) {
          refreshCalls++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          final result =
              jsonDecode(sessionResponse().body) as Map<String, dynamic>;
          result['accessToken'] = 'new-access';
          result['refreshToken'] = 'new-refresh';
          return http.Response(
            jsonEncode(result),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (r.headers['Authorization'] == 'Bearer test-access')
          return http.Response('{"message":"expired"}', 401);
        return http.Response(
          jsonEncode(userJson()),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await auth.login('9876543210', 'secret-pass-123');
    await Future.wait([auth.updateProfile({}), auth.updateProfile({})]);
    expect(refreshCalls, 1);
  });
  test('failed refresh signs out and clears both tokens', () async {
    final storage = MemorySession();
    var expired = 0;
    final auth = AuthService(
      storage: storage,
      baseUrl: 'http://test/api',
      client: MockClient((r) async {
        if (r.url.path.endsWith('/login')) return sessionResponse();
        return http.Response('{"message":"expired"}', 401);
      }),
    );
    auth.onExpired = () async {
      expired++;
    };
    await auth.login('9876543210', 'secret-pass-123');
    await expectLater(auth.updateProfile({}), throwsA(isA<AuthFailure>()));
    expect(storage.value, isNull);
    expect(auth.signedIn, isFalse);
    expect(expired, 1);
  });
  testWidgets('registration opens Home directly even without profile details', (
    tester,
  ) async {
    final auth = AuthService(
      storage: MemorySession(),
      client: MockClient((r) async {
        expect(r.url.path.endsWith('/register'), isTrue);
        return sessionResponse(complete: false);
      }),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(auth: auth, prepareAccount: (_) async {}),
        routes: {
          RoutesName.bottom_bar: (_) =>
              const Scaffold(body: Text('Direct Home')),
          RoutesName.profileSetup: (_) =>
              const Scaffold(body: Text('Must not open')),
        },
      ),
    );
    await tester.tap(find.byKey(const Key('auth_toggle')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('auth_name')), 'Test Farmer');
    await tester.enterText(find.byKey(const Key('auth_mobile')), '9876543210');
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'secret-pass-123',
    );
    await tester.enterText(
      find.byKey(const Key('auth_confirm')),
      'secret-pass-123',
    );
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Direct Home'), findsOneWidget);
    expect(find.text('Must not open'), findsNothing);
  });
  test(
    'cold startup renews expired access using saved refresh token',
    () async {
      final storage = MemorySession()
        ..value = jsonEncode({
          'accessToken': 'expired-access',
          'refreshToken': 'saved-refresh',
          'accessTokenExpiresAt': '2020-01-01T00:00:00Z',
          'refreshTokenExpiresAt': '2030-02-01T00:00:00Z',
        });
      var refreshes = 0;
      final auth = AuthService(
        storage: storage,
        baseUrl: 'http://test/api',
        client: MockClient((r) async {
          if (r.url.path.endsWith('/refresh')) {
            refreshes++;
            expect(jsonDecode(r.body)['refreshToken'], 'saved-refresh');
            return sessionResponse();
          }
          expect(r.url.path, '/api/auth/me');
          expect(r.headers['Authorization'], 'Bearer test-access');
          return http.Response(
            jsonEncode(userJson()),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      expect(await auth.restore(), isTrue);
      expect(refreshes, 1);
      expect(auth.user!.name, 'Ramesh Patel');
    },
  );
  test('logout cannot be undone by a delayed refresh storage write', () async {
    final storage = DelayedSession();
    final auth = AuthService(
      storage: storage,
      baseUrl: 'http://test/api',
      client: MockClient((r) async {
        if (r.url.path.endsWith('/logout')) return http.Response('', 204);
        return sessionResponse();
      }),
    );
    await auth.login('9876543210', 'secret-pass-123');
    storage.pause = true;
    final refreshing = expectLater(
      auth.refreshSession(),
      throwsA(
        isA<AuthFailure>().having((e) => e.code, 'code', 'SESSION_CHANGED'),
      ),
    );
    await storage.started.future;
    final loggingOut = auth.logout();
    storage.release.complete();
    await refreshing;
    await loggingOut;
    expect(storage.value, isNull);
    expect(auth.signedIn, isFalse);
  });
  testWidgets(
    'registration rejects invalid optional email before calling API',
    (tester) async {
      var calls = 0;
      final auth = AuthService(
        storage: MemorySession(),
        client: MockClient((r) async {
          calls++;
          return sessionResponse();
        }),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(auth: auth, prepareAccount: (_) async {}),
        ),
      );
      await tester.tap(find.byKey(const Key('auth_toggle')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('auth_name')), 'Test Farmer');
      await tester.enterText(
        find.byKey(const Key('auth_email')),
        'invalid-email',
      );
      await tester.enterText(
        find.byKey(const Key('auth_mobile')),
        '9876543210',
      );
      await tester.enterText(
        find.byKey(const Key('auth_password')),
        'secret-pass-123',
      );
      await tester.enterText(
        find.byKey(const Key('auth_confirm')),
        'secret-pass-123',
      );
      await tester.ensureVisible(find.byKey(const Key('auth_submit')));
      await tester.tap(find.byKey(const Key('auth_submit')));
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(find.text('सही email लिखें'), findsOneWidget);
    },
  );
}
