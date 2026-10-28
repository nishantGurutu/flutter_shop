import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/category_model.dart';
import 'package:shop/model/json_models/product_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;
import 'package:shop/view/widgets/common/product_tile.dart';
import 'package:shop/view/widgets/common/section_header.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Future<List<CategoryModel>> _categoriesFuture;
  late Future<List<ProductModel>> _productsFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = JsonDataService.loadCategories();
    _productsFuture = JsonDataService.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('खाद-बीज दुकान (Store)'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final count = state.items.fold<int>(0, (sum, item) => sum + item.quantity);
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => Navigator.pushNamed(context, RoutesName.cart),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: AppTheme.textHint),
                    prefixIcon: Icon(Icons.search, color: AppTheme.textHint),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Categories
            FutureBuilder<List<CategoryModel>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return _buildCategories(snapshot.data!);
              },
            ),
            SizedBox(height: 16.h),
            // Products Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SectionHeader(
                title: 'All Products',
                actionLabel: 'Filter',
              ),
            ),
            SizedBox(height: 12.h),
            // Products Grid
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load products',
              onRetry: () {
                setState(() {
                  _productsFuture = JsonDataService.loadProducts();
                });
              },
            );
          }

                  final products = snapshot.data!;
                  return _buildProductsGrid(products);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(List<CategoryModel> categories) {
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'build':
          return Icons.build;
        case 'grass':
          return Icons.grass;
        case 'bug_report':
          return Icons.bug_report;
        case 'shield':
          return Icons.shield;
        case 'eco':
          return Icons.eco;
        case 'agriculture':
          return Icons.agriculture;
        case 'pets':
          return Icons.pets;
        case 'opacity':
          return Icons.opacity;
        case 'more_horiz':
          return Icons.more_horiz;
        default:
          return Icons.circle;
      }
    }

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category.id;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = isSelected ? null : category.id;
              });
            },
            child: Container(
              width: 80.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Color(int.parse(category.bgColor.replaceAll('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Icon(
                      getIcon(category.icon),
                      color: isSelected
                          ? Colors.white
                          : Color(int.parse(category.color.replaceAll('#', '0xFF'))),
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(List<ProductModel> products) {
    final filteredProducts = _selectedCategory == null
        ? products
        : products.where((p) => p.category.toLowerCase() == _selectedCategory).toList();

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductTile(
          product: product,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.productDetails);
          },
          onAddToCart: () {
            final cartItem = CartItem(
              productId: product.id,
              name: '${product.name} ${product.subtitle}',
              image: product.image,
              price: product.price,
              quantity: 1,
              unit: product.unit,
            );
            context.read<CartBloc>().add(AddToCart(product: cartItem));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} कार्ट में जोड़ा गया!'),
                backgroundColor: AppTheme.success,
                action: SnackBarAction(
                  label: 'कार्ट देखें',
                  textColor: Colors.white,
                  onPressed: () => Navigator.pushNamed(context, RoutesName.cart),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
