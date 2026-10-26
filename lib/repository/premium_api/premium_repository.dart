import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';
import 'package:shop/model/profile/premium_package_model.dart';
import 'package:flutter/material.dart';

abstract class PremiumRepository extends BaseRepository<PremiumPackage> {
  Future<List<PremiumPackage>> fetchPackages();
}

class PremiumHttpRepository implements PremiumRepository {
  final NetworkService _networkService;

  PremiumHttpRepository(this._networkService);

  @override
  Future<List<PremiumPackage>> getAll() async {
    return await fetchPackages();
  }

  @override
  Future<PremiumPackage?> getById(String id) async {
    final packages = await fetchPackages();
    final filtered = packages.where((pkg) => pkg.title == id);
    return filtered.isEmpty ? null : filtered.first;
  }

  @override
  Future<PremiumPackage> create(PremiumPackage item) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<PremiumPackage> update(String id, PremiumPackage item) async {
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
  Future<List<PremiumPackage>> fetchPackages() async {
    return [
      const PremiumPackage(
        title: "12 MONTHS",
        subtitle: "Save Upto 50%",
        price: "\$100.00",
        gradientColors: [Color(0xFF4FA0C9), Color(0xFF3B7BA3)],
      ),
      const PremiumPackage(
        title: "6 MONTHS",
        subtitle: "GOLD PACKAGE",
        price: "\$60.00",
        gradientColors: [Color(0xFFE8B41E), Color(0xFFC78F04)],
      ),
      const PremiumPackage(
        title: "3 MONTHS",
        subtitle: "Save Upto 25%",
        price: "\$30.00",
        gradientColors: [Color(0xFFC67CF5), Color(0xFF9E54D4)],
      ),
      const PremiumPackage(
        title: "1 MONTHS",
        subtitle: "Save Upto 30%",
        price: "\$7.00",
        gradientColors: [Color(0xFF6C8EEF), Color(0xFF4B6AD6)],
      ),
      const PremiumPackage(
        title: "1 Day",
        subtitle: "Premium Pass",
        price: "\$1.00",
        gradientColors: [Color(0xFF49A349), Color(0xFF307630)],
      ),
    ];
  }
}
