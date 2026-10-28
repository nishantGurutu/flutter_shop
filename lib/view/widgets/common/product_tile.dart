import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/product_model.dart';
import 'package:shop/model/json_models/home_model.dart';

class ProductTile extends StatelessWidget {
  final dynamic product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductTile({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final String name = product is ProductModel
        ? (product as ProductModel).name
        : (product as ProductSummaryModel).name;
    final String subtitle = product is ProductModel
        ? (product as ProductModel).subtitle
        : (product as ProductSummaryModel).subtitle;
    final double price = product is ProductModel
        ? (product as ProductModel).price
        : (product as ProductSummaryModel).price;
    final String image = product is ProductModel
        ? (product as ProductModel).image
        : (product as ProductSummaryModel).image;
    final double rating = product is ProductModel
        ? (product as ProductModel).rating
        : (product as ProductSummaryModel).rating;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Center(
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[400],
                        size: 32.sp,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // Product Name
            Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Product Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Rating
            ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14.sp,
                  color: AppTheme.secondaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
            SizedBox(height: 10.h),
            // Price and Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
