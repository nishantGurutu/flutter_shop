import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/home_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;
import 'package:shop/view/widgets/common/product_tile.dart';
import 'package:shop/view/widgets/common/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<HomeDataModel> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = JsonDataService.loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<HomeDataModel>(
          future: _homeDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const common.LoadingWidget(message: 'Loading...');
            }

if (snapshot.hasError) {
            return common.ErrorDisplayWidget(message: 'Failed to load data', onRetry: () {
              setState(() {
                _homeDataFuture = JsonDataService.loadHomeData();
              });
            });
          }

            final homeData = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(homeData.user),
                    SizedBox(height: 14.h),
                    _buildWeatherCard(homeData.weather),
                    SizedBox(height: 20.h),
                    SectionHeader(
                      title: 'Quick Actions',
                      actionLabel: null,
                    ),
                    SizedBox(height: 12.h),
                    _buildQuickActions(homeData.quickActions),
                    SizedBox(height: 20.h),
                    SectionHeader(
                      title: 'Recommended For You',
                      actionLabel: 'View All',
                      onActionTap: () => Navigator.pushNamed(context, RoutesName.store),
                    ),
                    SizedBox(height: 12.h),
                    _buildRecommendedProducts(homeData.recommendations),
                    SizedBox(height: 20.h),
                    SectionHeader(
                      title: 'Offers For You',
                      actionLabel: 'View All',
                    ),
                    SizedBox(height: 12.h),
                    _buildOffersList(homeData.offers),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Namaste, ${user.name} ',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text('👋', style: TextStyle(fontSize: 17.sp)),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              user.location,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RoutesName.notification),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 22.sp,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard(WeatherModel weather) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppTheme.weatherGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0288D1).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temperature}°C',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                weather.condition,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                weather.location,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.wb_cloudy_outlined,
                color: Colors.white,
                size: 36.sp,
              ),
              SizedBox(height: 6.h),
              Text(
                '${weather.high}° / ${weather.low}°',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'H:${weather.humidity}%  W:${weather.windSpeed}km/h',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(List<QuickActionModel> actions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        return _buildQuickActionItem(action);
      }).toList(),
    );
  }

  Widget _buildQuickActionItem(QuickActionModel action) {
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'agriculture':
          return Icons.agriculture_rounded;
        case 'camera':
          return Icons.camera_alt_rounded;
        case 'chat':
          return Icons.chat_rounded;
        case 'replay':
          return Icons.replay_rounded;
        default:
          return Icons.circle;
      }
    }

    return GestureDetector(
      onTap: () {
        switch (action.id) {
          case 'buy_fertilizer':
            Navigator.pushNamed(context, RoutesName.store);
            break;
          case 'crop_doctor':
            Navigator.pushNamed(context, RoutesName.advice);
            break;
          case 'reorder':
            Navigator.pushNamed(context, RoutesName.order);
            break;
        }
      },
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Color(int.parse(action.bgColor.replaceAll('#', '0xFF'))),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(action.icon),
                  color: Color(int.parse(action.iconColor.replaceAll('#', '0xFF'))),
                  size: 22.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            action.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts(List<ProductSummaryModel> products) {
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 160.w,
            margin: EdgeInsets.only(right: 12.w),
            child: ProductTile(
              product: product,
              onTap: () => Navigator.pushNamed(context, RoutesName.productDetails),
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
                  const SnackBar(
                    content: Text('Product added to cart!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffersList(List<OfferModel> offers) {
    return Column(
      children: offers.map((offer) {
        return Container(
          width: double.infinity,
          height: 90.h,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: LinearGradient(
              colors: [
                Color(int.parse(offer.gradient[0].replaceAll('#', '0xFF'))),
                Color(int.parse(offer.gradient[1].replaceAll('#', '0xFF'))),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        offer.subtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                ),
                child: Image.asset(
                  offer.image,
                  width: 100.w,
                  height: 90.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100.w,
                      height: 90.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
