import 'package:shop/model/notification_model.dart';
import 'package:shop/repository/notification_api/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
    : super(NotificationState(alerts: [], notifications: [])) {
    on<LoadNotifications>((event, emit) async {
      final alerts = await notificationRepository.fetchAlerts();
      final notifications = await notificationRepository.fetchNotifications();
      emit(state.copyWith(alerts: alerts, notifications: notifications));
    });
  }
}
