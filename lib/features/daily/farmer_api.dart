import 'package:shop/features/auth/auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// Provider keys belong on the server. Enable with --dart-define=FARMER_API_URL=https://...
class FarmerApi {
  static const baseUrl = String.fromEnvironment('FARMER_API_URL');
  static bool get configured => baseUrl.isNotEmpty;
  static Future<Map<String, dynamic>> _decode(http.Response response) async {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'सेवा उपलब्ध नहीं (${response.statusCode}). कृपया फिर कोशिश करें।',
      );
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    if (!configured) throw StateError('Live backend अभी configure नहीं है।');
    final authHeaders = await AuthService.instance.freshAuthorizationHeaders();
    return _decode(
      await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json', ...authHeaders},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30)),
    );
  }

  static Future<Map<String, dynamic>> get(String path) async {
    if (!configured) throw StateError('Live backend अभी configure नहीं है।');
    final authHeaders = await AuthService.instance.freshAuthorizationHeaders();
    return _decode(
      await http
          .get(Uri.parse('$baseUrl$path'), headers: authHeaders)
          .timeout(const Duration(seconds: 30)),
    );
  }

  static Future<Map<String, dynamic>> diagnose(
    XFile photo,
    String crop,
    String symptoms,
  ) async {
    if (!configured) {
      throw StateError(
        'AI सेवा connect नहीं है। फोटो का diagnosis नहीं हुआ है।',
      );
    }
    final bytes = await photo.readAsBytes();
    if (bytes.length > 10 * 1024 * 1024) {
      throw StateError('10 MB से छोटी photo चुनें।');
    }
    final authHeaders = await AuthService.instance.freshAuthorizationHeaders();
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/crop-doctor'))
          ..headers.addAll({...authHeaders})
          ..fields.addAll({'crop': crop, 'symptoms': symptoms})
          ..files.add(
            http.MultipartFile.fromBytes('photo', bytes, filename: photo.name),
          );
    return _decode(
      await http.Response.fromStream(
        await request.send().timeout(const Duration(seconds: 60)),
      ),
    );
  }
}
