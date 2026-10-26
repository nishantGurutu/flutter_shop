import 'package:equatable/equatable.dart';

class CartDataModel extends Equatable {
  final List<CartItemModel> items;
  final CartSummaryModel summary;
  final DeliveryAddressModel deliveryAddress;

  const CartDataModel({
    required this.items,
    required this.summary,
    required this.deliveryAddress,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      items: (json['items'] as List)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: CartSummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
      deliveryAddress: DeliveryAddressModel.fromJson(
          json['deliveryAddress'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [items, summary, deliveryAddress];
}

class CartItemModel extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String unit;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
    );
  }

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [productId, name, image, price, quantity, unit];
}

class CartSummaryModel extends Equatable {
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double total;

  const CartSummaryModel({
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
    required this.total,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [subtotal, deliveryCharge, discount, total];
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
