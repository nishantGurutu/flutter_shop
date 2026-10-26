import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';
import 'package:shop/model/home/home_model.dart';

abstract class HomeRepository extends BaseRepository<UserModel> {
  Future<List<UserModel>> fetchUsers();
  Future<List<UserModel>> searchUsers(String query);
  Future<UserModel?> getUserById(String userId);
}

class HomeHttpRepository implements HomeRepository {
  final NetworkService _networkService;

  HomeHttpRepository(this._networkService);

  @override
  Future<List<UserModel>> fetchUsers() async {
    // TODO: Replace with actual API call
    // final response = await _networkService.get<List<UserModel>>(
    //   '/users',
    //   fromJson: (json) => (json as List).map((e) => UserModel.fromJson(e)).toList(),
    // );
    //
    // if (response.success && response.data != null) {
    //   return response.data!;
    // } else {
    //   throw NetworkException(response.error ?? 'Failed to fetch users');
    // }

    // Temporary mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    return _getMockUsers();
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final allUsers = await fetchUsers();
    return allUsers
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.profession.toLowerCase().contains(query.toLowerCase()) ||
              user.interests.any(
                (interest) =>
                    interest.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final users = await fetchUsers();
    return users.cast<UserModel?>().firstWhere(
      (user) => user?.id == userId,
      orElse: () => null,
    );
  }

  @override
  Future<List<UserModel>> getAll() => fetchUsers();

  @override
  Future<UserModel?> getById(String id) => getUserById(id);

  @override
  Future<UserModel> create(UserModel item) {
    // TODO: Implement create user API
    throw UnimplementedError('Create user not implemented');
  }

  @override
  Future<UserModel> update(String id, UserModel item) {
    // TODO: Implement update user API
    throw UnimplementedError('Update user not implemented');
  }

  @override
  Future<void> delete(String id) {
    // TODO: Implement delete user API
    throw UnimplementedError('Delete user not implemented');
  }

  List<UserModel> _getMockUsers() {
    return [
      UserModel(
        id: '1',
        name: "Lily James",
        age: 22,
        profession: "Students",
        imageUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Fashion, Arts",
        about:
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam",
        interests: ["Cinema", "Cooking", "Bicycle", "Cats", "Arts", "Fashion"],
      ),
      UserModel(
        id: '2',
        name: "Johansson",
        age: 22,
        profession: "Students",
        imageUrl:
            "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Music, Dance",
        about:
            "Dancing is my passion. Looking for someone who shares the same vibe and loves to explore new places.",
        interests: ["Dance", "Music", "Travel", "Foodie", "Fitness"],
      ),
      UserModel(
        id: '3',
        name: "Lily James",
        age: 22,
        profession: "Designer",
        imageUrl:
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Design, Creative",
        about:
            "Creative soul. Loves designing beautiful spaces and digital experiences. Let's create something together.",
        interests: ["Design", "Art", "UI/UX", "Coffee", "Sketching"],
      ),
      UserModel(
        id: '4',
        name: "Johansson",
        age: 22,
        profession: "Students",
        imageUrl:
            "https://images.pexels.com/photos/1587009/pexels-photo-1587009.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Tech, Gaming",
        about:
            "Tech enthusiast. Gamer at heart. Always curious about the latest innovations.",
        interests: ["Gaming", "Coding", "Movies", "Sci-Fi", "Chess"],
      ),
      UserModel(
        id: '5',
        name: "Emma Watson",
        age: 24,
        profession: "Artist",
        imageUrl:
            "https://images.pexels.com/photos/1462637/pexels-photo-1462637.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Art, Painting",
        about:
            "Painting my way through life. Seeking inspiration in the little things.",
        interests: ["Painting", "Museums", "Poetry", "Nature", "Yoga"],
      ),
      UserModel(
        id: '6',
        name: "Scarlett",
        age: 25,
        profession: "Model",
        imageUrl:
            "https://images.pexels.com/photos/1382731/pexels-photo-1382731.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Fashion, Photography",
        about:
            "In front of the lens. Capturing moments. Loving the city lights.",
        interests: ["Photography", "Fashion", "Travel", "Cityscape", "Coffee"],
      ),
      UserModel(
        id: '7',
        name: "Jennifer",
        age: 23,
        profession: "Developer",
        imageUrl:
            "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Software, Engineering",
        about:
            "Building the future, one line of code at a time. Coffee and code are my essentials.",
        interests: ["Coding", "Apps", "Open Source", "Hiking", "Reading"],
      ),
      UserModel(
        id: '8',
        name: "Natalie",
        age: 22,
        profession: "Students",
        imageUrl:
            "https://images.pexels.com/photos/1391498/pexels-photo-1391498.jpeg?auto=compress&cs=tinysrgb&w=600",
        role: "Education, Learning",
        about:
            "Always learning. Curious about history and cultures. Books are my best friends.",
        interests: ["Books", "History", "Cultures", "Study", "Language"],
      ),
    ];
  }
}
