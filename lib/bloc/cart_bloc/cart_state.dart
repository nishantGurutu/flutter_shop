part of 'cart_bloc.dart';

class CartItem extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String unit;

  const CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  CartItem copyWith({
    String? productId,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? unit,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object> get props => [productId, name, image, price, quantity, unit];
}

class CartState extends BaseState {
  final List<CartItem> items;

  const CartState({this.items = const [], super.isLoading, super.error});

  @override
  CartState copyWith({List<CartItem>? items, bool? isLoading, String? error}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error];
}
