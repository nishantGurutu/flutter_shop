import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String title;
  final String titleHi;
  final String icon;
  final String color;
  final String bgColor;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      titleHi: json['titleHi'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      bgColor: json['bgColor'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, titleHi, icon, color, bgColor];
}
