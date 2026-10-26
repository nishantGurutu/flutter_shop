import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/notification_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/custom_card.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationDataModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = JsonDataService.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationDataModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

          if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load notifications',
              onRetry: () {
                setState(() {
                  _notificationsFuture = JsonDataService.loadNotifications();
                });
              },
            );
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(notification);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationDataModel notification) {
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'thunderstorm':
          return Icons.thunderstorm_outlined;
        case 'agriculture':
          return Icons.agriculture_outlined;
        case 'local_shipping':
          return Icons.local_shipping_outlined;
        case 'local_offer':
          return Icons.local_offer_outlined;
        case 'chat':
          return Icons.chat_outlined;
        default:
          return Icons.notifications_outlined;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            Color(int.parse(notification.gradient[0].replaceAll('#', '0xFF'))),
            Color(int.parse(notification.gradient[1].replaceAll('#', '0xFF'))),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(int.parse(notification.color.replaceAll('#', '0xFF')))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                getIcon(notification.icon),
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    notification.time,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
