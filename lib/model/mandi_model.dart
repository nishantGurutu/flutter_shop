class MandiRateModel {
  final String id;
  final String mandiName;
  final String district;
  final String state;
  final String cropName;
  final String cropHindi;
  final String variety;
  final double minPrice;
  final double modalPrice;
  final double maxPrice;
  final double priceChange; // Positive or negative
  final String arrival;
  final String date;
  final String icon;

  const MandiRateModel({
    required this.id,
    required this.mandiName,
    required this.district,
    required this.state,
    required this.cropName,
    required this.cropHindi,
    required this.variety,
    required this.minPrice,
    required this.modalPrice,
    required this.maxPrice,
    required this.priceChange,
    required this.arrival,
    required this.date,
    required this.icon,
  });

  bool get isUp => priceChange > 0;
  bool get isDown => priceChange < 0;
}

class RateAlertModel {
  final String id;
  final String cropName;
  final String cropHindi;
  final String mandiName;
  final double targetPrice;
  final bool isAbove; // true: price >= target, false: price <= target
  final bool isActive;
  final String createdAt;

  const RateAlertModel({
    required this.id,
    required this.cropName,
    required this.cropHindi,
    required this.mandiName,
    required this.targetPrice,
    this.isAbove = true,
    this.isActive = true,
    required this.createdAt,
  });

  RateAlertModel copyWith({
    String? id,
    String? cropName,
    String? cropHindi,
    String? mandiName,
    double? targetPrice,
    bool? isAbove,
    bool? isActive,
    String? createdAt,
  }) {
    return RateAlertModel(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      cropHindi: cropHindi ?? this.cropHindi,
      mandiName: mandiName ?? this.mandiName,
      targetPrice: targetPrice ?? this.targetPrice,
      isAbove: isAbove ?? this.isAbove,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
