import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';
import 'package:shop/model/notification_model.dart';
import 'package:flutter/material.dart';

abstract class NotificationRepository
    extends BaseRepository<NotificationModel> {
  Future<List<AlertModel>> fetchAlerts();
  Future<List<NotificationModel>> fetchNotifications();
}

class NotificationHttpRepository implements NotificationRepository {
  final NetworkService _networkService;

  NotificationHttpRepository(this._networkService);

  @override
  Future<List<NotificationModel>> getAll() async {
    return await fetchNotifications();
  }

  @override
  Future<NotificationModel?> getById(String id) async {
    final notifications = await fetchNotifications();
    final filtered = notifications.where((notif) => notif.name == id);
    return filtered.isEmpty ? null : filtered.first;
  }

  @override
  Future<NotificationModel> create(NotificationModel item) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<NotificationModel> update(String id, NotificationModel item) async {
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
  Future<List<AlertModel>> fetchAlerts() async {
    return [
      const AlertModel(
        title: "Congrats!",
        body: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed",
        gradientColors: [Color(0xFFE89E23), Color(0xFFD47C04)],
        icon: Icons.notifications_none,
      ),
      const AlertModel(
        title: "",
        body: "Emma Stone sent you a message",
        gradientColors: [Color(0xFFC67CF5), Color(0xFFE08BFF)],
        icon: Icons.email_outlined,
      ),
      const AlertModel(
        title: "Congrats!",
        body: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed",
        gradientColors: [Color(0xFF90C26A), Color(0xFF7CAF54)],
        icon: Icons.notifications_none,
      ),
    ];
  }

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    return [
      const NotificationModel(
        name: "Allie Hall",
        action: "Mentioned You In Comment",
        body: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed",
        timeLabel: "1 Days ago",
        imageUrl:
            "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=600",
        isVerified: true,
      ),
      const NotificationModel(
        name: "Ricky Spenser",
        action: "Likes your profile",
        body: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed",
        timeLabel: "1 Days ago",
        imageUrl:
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=600",
        isVerified: true,
      ),
      const NotificationModel(
        name: "George Akins",
        action: "Visited Profile",
        body: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed",
        timeLabel: "1 Days ago",
        imageUrl:
            "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=600",
        isVerified: true,
      ),
    ];
  }
}
