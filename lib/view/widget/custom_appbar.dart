import 'package:flutter/material.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/view/widget/cart_icon.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onCartTap;
  final String? deliveryLocation;

  const CustomAppbar({
    super.key,
    this.titleText,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.onLocationTap,
    this.onCartTap,
    this.deliveryLocation,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Location
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: onLocationTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Deliver to',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            deliveryLocation ?? '382435',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            
            // Center - Logo/Title
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  titleText ?? 'Krishi Saathi',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Right side - Profile
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CartIcon(
                    onTap: onCartTap ?? () {
                      Navigator.pushNamed(context, RoutesName.cart);
                    },
                    color: Colors.black,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onNotificationTap,
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                          size: 24,
                        ),
                        Positioned(
                          right: 0,
                          top: 2,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 18,
                      ),
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