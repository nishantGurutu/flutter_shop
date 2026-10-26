part of 'notification_bloc.dart';

class NotificationState {
  final List<AlertModel> alerts;
  final List<NotificationModel> notifications;

  NotificationState({required this.alerts, required this.notifications});

  NotificationState copyWith({
    List<AlertModel>? alerts,
    List<NotificationModel>? notifications,
  }) {
    return NotificationState(
      alerts: alerts ?? this.alerts,
      notifications: notifications ?? this.notifications,
    );
  }
}
