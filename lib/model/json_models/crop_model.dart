import 'package:equatable/equatable.dart';

class CropModel extends Equatable {
  final String id;
  final String name;
  final String nameHi;
  final String image;
  final String area;
  final String areaUnit;
  final String sowingDate;
  final String expectedHarvest;
  final String health;
  final String healthColor;
  final String stage;
  final int stageProgress;
  final String nextActivity;
  final String nextActivityDate;

  const CropModel({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.image,
    required this.area,
    required this.areaUnit,
    required this.sowingDate,
    required this.expectedHarvest,
    required this.health,
    required this.healthColor,
    required this.stage,
    required this.stageProgress,
    required this.nextActivity,
    required this.nextActivityDate,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameHi: json['nameHi'] as String,
      image: json['image'] as String,
      area: json['area'] as String,
      areaUnit: json['areaUnit'] as String,
      sowingDate: json['sowingDate'] as String,
      expectedHarvest: json['expectedHarvest'] as String,
      health: json['health'] as String,
      healthColor: json['healthColor'] as String,
      stage: json['stage'] as String,
      stageProgress: json['stageProgress'] as int,
      nextActivity: json['nextActivity'] as String,
      nextActivityDate: json['nextActivityDate'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameHi,
        image,
        area,
        areaUnit,
        sowingDate,
        expectedHarvest,
        health,
        healthColor,
        stage,
        stageProgress,
        nextActivity,
        nextActivityDate,
      ];
}
