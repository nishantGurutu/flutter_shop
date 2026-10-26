import 'package:equatable/equatable.dart';

class HomeDataModel extends Equatable {
  final UserModel user;
  final WeatherModel weather;
  final List<QuickActionModel> quickActions;
  final List<ProductSummaryModel> recommendations;
  final List<OfferModel> offers;

  const HomeDataModel({
    required this.user,
    required this.weather,
    required this.quickActions,
    required this.recommendations,
    required this.offers,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      weather: WeatherModel.fromJson(json['weather'] as Map<String, dynamic>),
      quickActions: (json['quick_actions'] as List)
          .map((e) => QuickActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map((e) => ProductSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List)
          .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [user, weather, quickActions, recommendations, offers];
}

class UserModel extends Equatable {
  final String name;
  final String location;
  final String avatar;

  const UserModel({
    required this.name,
    required this.location,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      location: json['location'] as String,
      avatar: json['avatar'] as String,
    );
  }

  @override
  List<Object?> get props => [name, location, avatar];
}

class WeatherModel extends Equatable {
  final int temperature;
  final String condition;
  final int high;
  final int low;
  final int humidity;
  final int windSpeed;
  final String location;

  const WeatherModel({
    required this.temperature,
    required this.condition,
    required this.high,
    required this.low,
    required this.humidity,
    required this.windSpeed,
    required this.location,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temperature'] as int,
      condition: json['condition'] as String,
      high: json['high'] as int,
      low: json['low'] as int,
      humidity: json['humidity'] as int,
      windSpeed: json['windSpeed'] as int,
      location: json['location'] as String,
    );
  }

  @override
  List<Object?> get props => [temperature, condition, high, low, humidity, windSpeed, location];
}

class QuickActionModel extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String bgColor;
  final String iconColor;
  final String route;

  const QuickActionModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.route,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      bgColor: json['bgColor'] as String,
      iconColor: json['iconColor'] as String,
      route: json['route'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, icon, bgColor, iconColor, route];
}

class ProductSummaryModel extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String unit;
  final double rating;
  final String image;

  const ProductSummaryModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.unit,
    required this.rating,
    required this.image,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, subtitle, price, unit, rating, image];
}

class OfferModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final List<String> gradient;
  final String image;

  const OfferModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.image,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      gradient: (json['gradient'] as List).cast<String>(),
      image: json['image'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, gradient, image];
}
