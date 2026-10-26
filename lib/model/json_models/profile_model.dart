import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final UserProfileModel user;
  final List<MenuItemModel> menuItems;
  final UserStatsModel stats;

  const ProfileModel({
    required this.user,
    required this.menuItems,
    required this.stats,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: UserProfileModel.fromJson(json['user'] as Map<String, dynamic>),
      menuItems: (json['menuItems'] as List)
          .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [user, menuItems, stats];
}

class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String nameHi;
  final String phone;
  final String email;
  final String avatar;
  final LocationModel location;
  final String landSize;
  final String landUnit;
  final String memberSince;
  final String language;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.location,
    required this.landSize,
    required this.landUnit,
    required this.memberSince,
    required this.language,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameHi: json['nameHi'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      landSize: json['landSize'] as String,
      landUnit: json['landUnit'] as String,
      memberSince: json['memberSince'] as String,
      language: json['language'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameHi,
        phone,
        email,
        avatar,
        location,
        landSize,
        landUnit,
        memberSince,
        language,
      ];
}

class LocationModel extends Equatable {
  final String village;
  final String district;
  final String state;
  final String pincode;

  const LocationModel({
    required this.village,
    required this.district,
    required this.state,
    required this.pincode,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      village: json['village'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
    );
  }

  String get fullAddress => '$village, $district, $state - $pincode';

  @override
  List<Object?> get props => [village, district, state, pincode];
}

class MenuItemModel extends Equatable {
  final String id;
  final String title;
  final String titleHi;
  final String icon;
  final String route;

  const MenuItemModel({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.icon,
    required this.route,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      titleHi: json['titleHi'] as String,
      icon: json['icon'] as String,
      route: json['route'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, titleHi, icon, route];
}

class UserStatsModel extends Equatable {
  final int totalOrders;
  final double totalSpent;
  final int cropsManaged;
  final int advisorySessions;

  const UserStatsModel({
    required this.totalOrders,
    required this.totalSpent,
    required this.cropsManaged,
    required this.advisorySessions,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalOrders: json['totalOrders'] as int,
      totalSpent: (json['totalSpent'] as num).toDouble(),
      cropsManaged: json['cropsManaged'] as int,
      advisorySessions: json['advisorySessions'] as int,
    );
  }

  @override
  List<Object?> get props => [totalOrders, totalSpent, cropsManaged, advisorySessions];
}
