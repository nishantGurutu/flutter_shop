import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> initialize() async {
    // No initialization needed for Secure Storage, but kept for compatibility
  }

  static Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  static const String _keyCustomerId = "customerId";
  static const String _keyCompanyId = "companyId";
  static const String _keyOrgId = "orgId";
  static const String _keyOrgName = "orgName";
  static const String _keyCustomerCode = "customerCode";
  static const String _keyCustomerName = "customerName";
  static const String _keyEmail = "categoryId";
  static const String _keyJwtToken = "token";

  static Future<void> setId(int id) async =>
      await _secureStorage.write(key: _keyCustomerId, value: id.toString());

  static Future<void> setCompanyId(int companyId) async => await _secureStorage
      .write(key: _keyCompanyId, value: companyId.toString());

  static Future<void> setOrgId(int orgId) async =>
      await _secureStorage.write(key: _keyOrgId, value: orgId.toString());

  static Future<void> setOrgName(String orgName) async =>
      await _secureStorage.write(key: _keyOrgName, value: orgName);

  static Future<void> setCustomerCode(String customerCode) async =>
      await _secureStorage.write(key: _keyCustomerCode, value: customerCode);

  static Future<void> setCustomerName(String customerName) async =>
      await _secureStorage.write(key: _keyCustomerName, value: customerName);

  static Future<void> setEmail(String email) async =>
      await _secureStorage.write(key: _keyEmail, value: email);

  static Future<void> setJwtToken(String jwtToken) async =>
      await _secureStorage.write(key: _keyJwtToken, value: jwtToken);

  static Future<int?> getId() async {
    final value = await _secureStorage.read(key: _keyCustomerId);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<int?> getCompany() async {
    final value = await _secureStorage.read(key: _keyCompanyId);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<int?> getOrgId() async {
    final value = await _secureStorage.read(key: _keyOrgId);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<String?> getOrgName() async =>
      await _secureStorage.read(key: _keyOrgName);

  static Future<String?> getCustomerCode() async =>
      await _secureStorage.read(key: _keyCustomerCode);

  static Future<String?> getCustomerName() async =>
      await _secureStorage.read(key: _keyCustomerName);

  static Future<String?> getEmail() async =>
      await _secureStorage.read(key: _keyEmail);

  static Future<String?> getJwtToken() async =>
      await _secureStorage.read(key: _keyJwtToken);
}
