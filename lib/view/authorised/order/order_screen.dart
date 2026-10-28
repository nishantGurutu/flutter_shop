import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shop/bloc/order_bloc/order_bloc.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/order_model.dart' as json_model;
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<json_model.OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _ordersFuture = JsonDataService.loadOrders();
    context.read<OrderBloc>().add(LoadOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Processing'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Delivery'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: FutureBuilder<List<json_model.OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

          if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load orders',
              onRetry: () {
                setState(() {
                  _ordersFuture = JsonDataService.loadOrders();
                });
              },
            );
          }

          final orders = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(orders), // All
              _buildOrderList(orders.where((o) => o.status == json_model.OrderStatus.processing).toList()),
              _buildOrderList(orders.where((o) => o.status == json_model.OrderStatus.confirmed).toList()),
              _buildOrderList(orders.where((o) => o.status == json_model.OrderStatus.onTheWay || o.status == json_model.OrderStatus.delivered).toList()),
              _buildOrderList(orders.where((o) => o.status == json_model.OrderStatus.cancelled).toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<json_model.OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No orders in this category',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(json_model.OrderModel order) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('dd MMM yyyy').format(order.orderDate),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...order.items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.asset(
                                item.image,
                                width: 40.w,
                                height: 40.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 40.w,
                                    height: 40.h,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image_not_supported, size: 20.sp),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                '${item.name} x${item.quantity}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 12.h),
                const Divider(),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (order.status == json_model.OrderStatus.processing ||
              order.status == json_model.OrderStatus.confirmed)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Cancel order
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppTheme.error,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Track order
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Track Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(json_model.OrderStatus status) {
    switch (status) {
      case json_model.OrderStatus.processing:
        return AppTheme.warning;
      case json_model.OrderStatus.confirmed:
        return AppTheme.info;
      case json_model.OrderStatus.onTheWay:
        return AppTheme.accentColor;
      case json_model.OrderStatus.delivered:
        return AppTheme.success;
      case json_model.OrderStatus.cancelled:
        return AppTheme.error;
    }
  }

  String _getStatusText(json_model.OrderStatus status) {
    switch (status) {
      case json_model.OrderStatus.processing:
        return 'Processing';
      case json_model.OrderStatus.confirmed:
        return 'Confirmed';
      case json_model.OrderStatus.onTheWay:
        return 'On The Way';
      case json_model.OrderStatus.delivered:
        return 'Delivered';
      case json_model.OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
