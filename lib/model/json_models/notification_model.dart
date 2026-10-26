import 'package:equatable/equatable.dart';

class NotificationDataModel extends Equatable {
  final String id;
  final String type;
  final String title;
  final String body;
  final String icon;
  final String color;
  final String time;
  final bool isRead;
  final List<String> gradient;

  const NotificationDataModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    required this.time,
    required this.isRead,
    required this.gradient,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      time: json['time'] as String,
      isRead: json['isRead'] as bool,
      gradient: (json['gradient'] as List).cast<String>(),
    );
  }

  @override
  List<Object?> get props => [id, type, title, body, icon, color, time, isRead, gradient];
}
