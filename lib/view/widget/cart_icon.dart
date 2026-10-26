import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';

class CartIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final double? size;

  const CartIcon({
    super.key,
    this.onTap,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final itemCount = state.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );

        return GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: color ?? Colors.black,
                size: size ?? 24,
              ),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        itemCount > 9 ? '9+' : itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
