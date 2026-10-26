import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';

abstract class AuthRepository extends BaseRepository<Map<String, dynamic>> {
  Future<bool> login(String email, String password);
  Future<void> logout();
}

class AuthHttpApiRepository implements AuthRepository {
  final NetworkService _networkService;

  AuthHttpApiRepository(this._networkService);

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    // Auth repository doesn't support getting all users
    return [];
  }

  @override
  Future<Map<String, dynamic>?> getById(String id) async {
    // Mock implementation - return user profile if logged in
    return {'userId': id, 'isLoggedIn': true};
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> item) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> item,
  ) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<void> delete(String id) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Mock success
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
