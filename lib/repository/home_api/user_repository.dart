import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';

abstract class UserRepository extends BaseRepository<Map<String, dynamic>> {
  Future<Map<String, dynamic>> fetchProfile();
  Future<void> updateProfile(Map<String, dynamic> data);
}

class UserHttpRepository implements UserRepository {
  final NetworkService _networkService;

  UserHttpRepository(this._networkService);

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    return [];
  }

  @override
  Future<Map<String, dynamic>?> getById(String id) async {
    return await fetchProfile();
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> item,
  ) async {
    await updateProfile(item);
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<Map<String, dynamic>> fetchProfile() async {
    return {
      "firstName": "Emma",
      "lastName": "Stone",
      "phoneNumber": "9995550100",
      "countryCode": "+01",
      "email": "Emma.stone999@mail.com",
      "gender": "Female",
      "address": "777 Brockton Avenue, Abington MA 2351",
      "imageUrl":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600",
    };
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
