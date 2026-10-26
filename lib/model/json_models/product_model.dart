import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String unit;
  final double rating;
  final int reviewCount;
  final String image;
  final String description;
  final List<String> benefits;
  final String category;
  final bool inStock;
  final int discount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.description,
    required this.benefits,
    required this.category,
    required this.inStock,
    required this.discount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      image: json['image'] as String,
      description: json['description'] as String,
      benefits: (json['benefits'] as List).cast<String>(),
      category: json['category'] as String,
      inStock: json['inStock'] as bool,
      discount: json['discount'] as int,
    );
  }

  double get discountedPrice {
    if (discount > 0) {
      return price - (price * discount / 100);
    }
    return price;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        subtitle,
        price,
        unit,
        rating,
        reviewCount,
        image,
        description,
        benefits,
        category,
        inStock,
        discount,
      ];
}
