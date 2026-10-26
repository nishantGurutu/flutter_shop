part of 'order_bloc.dart';

enum OrderStatus {
  processing,
  confirmed,
  onTheWay,
  delivered,
  cancelled,
}

class Order extends Equatable {
  final String id;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
  });

  Order copyWith({
    String? id,
    DateTime? orderDate,
    OrderStatus? status,
    double? totalAmount,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [id, orderDate, status, totalAmount, items];
}

class OrderItem extends Equatable {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object> get props => [name, quantity, price];
}

class OrderState extends Equatable {
  final bool isLoading;
  final List<Order> orders;
  final String? error;

  const OrderState({
    this.isLoading = false,
    this.orders = const [],
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    List<Order>? orders,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, orders, error];
}
