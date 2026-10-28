import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final dynamic id;
  final dynamic name;
  final dynamic age;
  final dynamic profession;
  final dynamic imageUrl;
  final List<dynamic> interests;
  final dynamic about;
  final dynamic role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.profession,
    required this.imageUrl,
    this.interests = const [],
    this.about = "",
    this.role = "",
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'] as dynamic ?? '',
      name: json['name'] as dynamic ?? '',
      age: json['age'] as int? ?? 0,
      profession: json['profession'] as dynamic ?? '',
      imageUrl: json['imageUrl'] as dynamic ?? '',
      interests: (json['interests'] as List<dynamic>?)?.cast<dynamic>() ?? [],
      about: json['about'] as dynamic ?? '',
      role: json['role'] as dynamic ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as dynamic)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as dynamic)
          : null,
    );
  }

  /// Convert UserModel to JSON
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'profession': profession,
      'imageUrl': imageUrl,
      'interests': interests,
      'about': about,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    dynamic id,
    dynamic name,
    int? age,
    dynamic profession,
    dynamic imageUrl,
    List<dynamic>? interests,
    dynamic about,
    dynamic role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      profession: profession ?? this.profession,
      imageUrl: imageUrl ?? this.imageUrl,
      interests: interests ?? this.interests,
      about: about ?? this.about,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if user has a specific interest
  bool hasInterest(dynamic interest) {
    return interests.contains(interest);
  }

  /// Get user's display name (name + age)
  dynamic get displayName => '$name, $age';

  /// Check if user profile is complete
  bool get isProfileComplete {
    return name.isNotEmpty &&
        profession.isNotEmpty &&
        about.isNotEmpty &&
        interests.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    profession,
    imageUrl,
    interests,
    about,
    role,
    createdAt,
    updatedAt,
  ];

  @override
  dynamic todynamic() {
    return 'UserModel(id: $id, name: $name, age: $age, profession: $profession)';
  }
}
