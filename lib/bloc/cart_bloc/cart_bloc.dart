import 'package:equatable/equatable.dart';
import 'package:shop/core/base_classes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends BaseBloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.productId == event.product.productId,
    );

    List<CartItem> updatedItems;
    if (existingItemIndex != -1) {
      // Item exists, update quantity
      updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
          .copyWith(quantity: updatedItems[existingItemIndex].quantity + 1);
    } else {
      // Add new item
      updatedItems = [...state.items, event.product];
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedItems = state.items
        .where((item) => item.productId != event.productId)
        .toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCart(productId: event.productId));
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(state.copyWith(items: []));
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    // TODO: Implement loading cart from storage/API
    // For now, just emit current state
    emit(state);
  }

  double get totalAmount {
    return state.items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  int get totalItems {
    return state.items.fold(0, (sum, item) => sum + item.quantity);
  }
}
