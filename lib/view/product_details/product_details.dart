import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/product_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<List<ProductModel>> _productsFuture;
  int _selectedProductIndex = 0;

  @override
  void initState() {
    super.initState();
    _productsFuture = JsonDataService.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product Details',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

          if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load product',
              onRetry: () {
                setState(() {
                  _productsFuture = JsonDataService.loadProducts();
                });
              },
            );
          }

          final products = snapshot.data!;
          final product = products[_selectedProductIndex];

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        // Product Image
                        Container(
                          height: 300.h,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey[400],
                                    size: 64.sp,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Related Products
                        _buildRelatedProducts(products),
                        SizedBox(height: 12.h),
                        // Product Info
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (product.discount > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        '${product.discount}% OFF',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppTheme.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                product.subtitle,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 18.sp,
                                    color: AppTheme.secondaryColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${product.rating}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '(${product.reviewCount} reviews)',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    product.unit,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Text(
                                    '₹${product.discountedPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  if (product.discount > 0) ...[
                                    SizedBox(width: 8.w),
                                    Text(
                                      '₹${product.price.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        decoration: TextDecoration.lineThrough,
                                        color: AppTheme.textHint,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                product.description,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppTheme.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Key Benefits',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...product.benefits.map(
                                (benefit) => _buildBenefitItem(benefit),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
                // Bottom Action Bar
                _buildBottomBar(product),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRelatedProducts(List<ProductModel> products) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isSelected = index == _selectedProductIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedProductIndex = index;
              });
            },
            child: Container(
              width: 70.w,
              height: 70.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : const Color(0xFFE0E0E0),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18.sp, color: AppTheme.success),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductModel product) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final cartItem = CartItem(
                  productId: product.id,
                  name: product.name,
                  image: product.image,
                  price: product.discountedPrice,
                  quantity: 1,
                  unit: product.unit,
                );
                context.read<CartBloc>().add(AddToCart(product: cartItem));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added to cart!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.primaryColor),
                ),
                child: Center(
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final cartItem = CartItem(
                  productId: product.id,
                  name: product.name,
                  image: product.image,
                  price: product.discountedPrice,
                  quantity: 1,
                  unit: product.unit,
                );
                context.read<CartBloc>().add(AddToCart(product: cartItem));
                Navigator.pushNamed(context, RoutesName.cart);
              },
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
