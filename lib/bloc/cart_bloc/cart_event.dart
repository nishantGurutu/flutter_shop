part of 'cart_bloc.dart';

abstract class CartEvent extends BaseEvent {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final CartItem product;

  const AddToCart({required this.product});

  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class LoadCart extends CartEvent {
  const LoadCart();
}
