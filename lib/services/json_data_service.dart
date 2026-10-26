import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shop/model/json_models/home_model.dart';
import 'package:shop/model/json_models/product_model.dart';
import 'package:shop/model/json_models/category_model.dart';
import 'package:shop/model/json_models/order_model.dart';
import 'package:shop/model/json_models/profile_model.dart';
import 'package:shop/model/json_models/notification_model.dart';
import 'package:shop/model/json_models/crop_model.dart';
import 'package:shop/model/json_models/advisory_model.dart';
import 'package:shop/model/json_models/cart_model.dart';

class JsonDataService {
  static Future<HomeDataModel> loadHomeData() async {
    final String jsonString = await rootBundle.loadString('assets/json/home.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return HomeDataModel.fromJson(json);
  }

  static Future<List<ProductModel>> loadProducts() async {
    final String jsonString = await rootBundle.loadString('assets/json/products.json');
    final List<dynamic> json = jsonDecode(jsonString);
    return json.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<CategoryModel>> loadCategories() async {
    final String jsonString = await rootBundle.loadString('assets/json/categories.json');
    final List<dynamic> json = jsonDecode(jsonString);
    return json.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<OrderModel>> loadOrders() async {
    final String jsonString = await rootBundle.loadString('assets/json/orders.json');
    final List<dynamic> json = jsonDecode(jsonString);
    return json.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<ProfileModel> loadProfile() async {
    final String jsonString = await rootBundle.loadString('assets/json/profile.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ProfileModel.fromJson(json);
  }

  static Future<List<NotificationDataModel>> loadNotifications() async {
    final String jsonString = await rootBundle.loadString('assets/json/notifications.json');
    final List<dynamic> json = jsonDecode(jsonString);
    return json.map((e) => NotificationDataModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<CropModel>> loadCrops() async {
    final String jsonString = await rootBundle.loadString('assets/json/crops.json');
    final List<dynamic> json = jsonDecode(jsonString);
    return json.map((e) => CropModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<AdvisoryModel> loadAdvisory() async {
    final String jsonString = await rootBundle.loadString('assets/json/advisory.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AdvisoryModel.fromJson(json);
  }

  static Future<CartDataModel> loadCart() async {
    final String jsonString = await rootBundle.loadString('assets/json/cart.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return CartDataModel.fromJson(json);
  }
}
