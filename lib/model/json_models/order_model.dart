import 'package:equatable/equatable.dart';

enum OrderStatus {
  processing,
  confirmed,
  onTheWay,
  delivered,
  cancelled,
}

class OrderModel extends Equatable {
  final String id;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItemModel> items;
  final DeliveryAddressModel deliveryAddress;
  final String paymentMethod;

  const OrderModel({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: _parseOrderStatus(json['status'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryAddress: DeliveryAddressModel.fromJson(
          json['deliveryAddress'] as Map<String, dynamic>),
      paymentMethod: json['paymentMethod'] as String,
    );
  }

  static OrderStatus _parseOrderStatus(String status) {
    switch (status) {
      case 'processing':
        return OrderStatus.processing;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'onTheWay':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.processing;
    }
  }

  @override
  List<Object?> get props => [id, orderDate, status, totalAmount, items, deliveryAddress, paymentMethod];
}

class OrderItemModel extends Equatable {
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String unit;

  const OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    required this.unit,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      unit: json['unit'] as String,
    );
  }

  @override
  List<Object?> get props => [name, quantity, price, image, unit];
}

class DeliveryAddressModel extends Equatable {
  final String name;
  final String address;
  final String phone;

  const DeliveryAddressModel({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
    );
  }

  @override
  List<Object?> get props => [name, address, phone];
}
