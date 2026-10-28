import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/home_model.dart';
import 'package:shop/services/farmer_profile_service.dart';
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
  final _profileService = FarmerProfileService();

  @override
  void initState() {
    super.initState();
    _homeDataFuture = JsonDataService.loadHomeData();
    _profileService.addListener(_onProfileUpdate);
  }

  @override
  void dispose() {
    _profileService.removeListener(_onProfileUpdate);
    super.dispose();
  }

  void _onProfileUpdate() {
    if (mounted) setState(() {});
  }

  void _showQuickVoiceModal() {
    final samplePrompts = [
      '2 बोरी डीएपी खाद 2700 रुपये',
      'ट्रैक्टर जुताई डीजल 1500 रुपये',
      '10 क्विंटल गेहूं बेचा 26000 रुपये',
      'कीटनाशक स्प्रे दवा 950 रुपये',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                '🎙️ बोलकर खर्च या कमाई जोड़ें',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'नीचे दिए गए उदाहरण पर टैप करें या खाता स्क्रीन में बोलें:',
                style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: samplePrompts.map((p) {
                  return ActionChip(
                    avatar: const Icon(Icons.mic, size: 16, color: AppTheme.primaryColor),
                    label: Text(p, style: TextStyle(fontSize: 12.sp)),
                    backgroundColor: const Color(0xFFF1F8E9),
                    side: const BorderSide(color: Color(0xFFC8E6C9)),
                    onPressed: () {
                      final entry = _profileService.parseVoiceInput(p);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('खाते में जुड़ा: ${entry.category} - ₹${entry.amount.toStringAsFixed(0)}'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutesName.khata);
                  },
                  child: const Text('पूरा खाता खोलें (Open Khata)'),
                ),
              ),
            ],
          ),
        );
      },
    );
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
              return const common.LoadingWidget(message: 'डेटा लोड हो रहा है...');
            }

            if (snapshot.hasError) {
              return common.ErrorDisplayWidget(
                message: 'Failed to load data',
                onRetry: () {
                  setState(() {
                    _homeDataFuture = JsonDataService.loadHomeData();
                  });
                },
              );
            }

            final homeData = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header (Farmer Name, Gaon/Zila, Notification & Cart actions)
                    _buildTopHeader(),

                    SizedBox(height: 14.h),

                    // 2. Subah ka Daily Bulletin Banner (Phase 1 Requirement)
                    _buildMorningBulletinBanner(),

                    SizedBox(height: 14.h),

                    // 3. Mausam & Spray / Sinchai Seedhi Salah Card (Phase 1 Requirement)
                    _buildWeatherAndAdvisoryCard(),

                    SizedBox(height: 18.h),

                    // 4. Quick Actions
                    _buildQuickActionGrid(),

                    SizedBox(height: 20.h),

                    // 5. Live Mandi Bhaav Ticker & Rate Alert (Phase 1 Requirement)
                    _buildMandiSectionHeader(),
                    SizedBox(height: 10.h),
                    _buildMandiTicker(),

                    SizedBox(height: 20.h),

                    // 6. Kisan Khata (Kharcha / Kamai) with Voice Input (Phase 1 Requirement)
                    _buildKhataSummaryWidget(),

                    SizedBox(height: 20.h),

                    // 7. Khaad & Beej Shop (Fertilizer and Products - Add to Cart Requirement)
                    SectionHeader(
                      title: 'खाद व उर्वरक (Shop Fertilizers)',
                      actionLabel: 'सभी देखें',
                      onActionTap: () => Navigator.pushNamed(context, RoutesName.store),
                    ),
                    SizedBox(height: 12.h),
                    _buildRecommendedProducts(homeData.recommendations),

                    SizedBox(height: 20.h),

                    // 8. Offers
                    SectionHeader(
                      title: 'विशेष छूट व योजनाएं (Offers)',
                      actionLabel: null,
                    ),
                    SizedBox(height: 12.h),
                    _buildOffersList(homeData.offers),

                    SizedBox(height: 70.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final count = state.items.fold<int>(0, (sum, i) => sum + i.quantity);
          if (count == 0) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            backgroundColor: AppTheme.primaryDark,
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Text(
              'कार्ट ($count बैग/सामान)',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, RoutesName.cart),
          );
        },
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'नमस्ते, ${_profileService.name} ',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text('🌾', style: TextStyle(fontSize: 18.sp)),
                ],
              ),
              SizedBox(height: 3.h),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.profileSetup),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 14),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        '${_profileService.village}, ${_profileService.district}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Cart Icon with Dynamic Badge
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final count = state.items.fold<int>(0, (sum, item) => sum + item.quantity);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RoutesName.cart),
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 20.sp,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (count > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        SizedBox(width: 10.w),

        // Notification Bell
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RoutesName.notification),
          child: Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 21.sp,
                  color: AppTheme.textPrimary,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMorningBulletinBanner() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, RoutesName.notification),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wb_twilight, color: Color(0xFFFFD54F), size: 22),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '🌅 आज का दैनिक बुलेटिन',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '7:00 AM',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'मौसम: 27°C साफ़ • गेहूं मंडी: ₹2,650 (+₹45) • स्प्रे अनुकूल',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 13),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherAndAdvisoryCard() {
    final advisory = _profileService.weatherAdvisory;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, RoutesName.weatherAdvisory),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: AppTheme.weatherGradient,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0288D1).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${advisory.temperature}°C',
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      advisory.condition,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'अधिकतम ${advisory.highTemp}° / न्यूनतम ${advisory.lowTemp}° • हवा ${advisory.windSpeed} km/h',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.wb_sunny_rounded,
                      color: const Color(0xFFFFD54F),
                      size: 42.sp,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          'पूरी सलाह देखें',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Spray & Sinchai Quick Indicator Pills
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.sanitizer, color: Colors.white, size: 15),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'स्प्रे: आज अनुकूल ✅',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 16.h, color: Colors.white30),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop, color: Colors.white, size: 15),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'सिंचाई: 4 दिन बारिश नहीं',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Widget _buildQuickActionGrid() {
    final actions = [
      {
        'title': 'मंडी भाव\nव अलर्ट',
        'icon': Icons.storefront_rounded,
        'color': '#2E7D32',
        'bg': '#E8F5E9',
        'route': RoutesName.mandi,
      },
      {
        'title': 'मौसम व\nस्प्रे सलाह',
        'icon': Icons.sanitizer_rounded,
        'color': '#0288D1',
        'bg': '#E1F5FE',
        'route': RoutesName.weatherAdvisory,
      },
      {
        'title': 'किसान\nखाता 🎙️',
        'icon': Icons.mic_rounded,
        'color': '#E65100',
        'bg': '#FFF3E0',
        'route': RoutesName.khata,
      },
      {
        'title': 'खाद-बीज\nदुकान',
        'icon': Icons.shopping_bag_rounded,
        'color': '#6A1B9A',
        'bg': '#F3E5F5',
        'route': RoutesName.store,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, act['route'] as String);
          },
          child: Column(
            children: [
              Container(
                width: 68.w,
                height: 68.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: Color(int.parse((act['bg'] as String).replaceAll('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      act['icon'] as IconData,
                      color: Color(int.parse((act['color'] as String).replaceAll('#', '0xFF'))),
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                act['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  height: 1.25,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMandiSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'ताज़ा मंडी भाव',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                _profileService.selectedMandi,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RoutesName.mandi),
          child: Text(
            'सभी भाव देखें >',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMandiTicker() {
    final rates = _profileService.mandiRates;

    return SizedBox(
      height: 104.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rates.length,
        itemBuilder: (context, index) {
          final r = rates[index];
          return Container(
            width: 145.w,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: AppTheme.cardShadow,
              border: Border.all(color: const Color(0xFFEFEFEF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        r.cropHindi.split(' ')[0],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      r.isUp ? '🔺' : (r.isDown ? '🔻' : '⚪'),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
                Text(
                  '₹${r.modalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '/ क्विंटल',
                      style: TextStyle(fontSize: 10.sp, color: AppTheme.textHint),
                    ),
                    Text(
                      '${r.isUp ? "+" : ""}${r.priceChange.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: r.isUp ? AppTheme.success : (r.isDown ? AppTheme.error : Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKhataSummaryWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book, color: AppTheme.secondaryColor, size: 16),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'किसान खाता (Khata)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.khata),
                child: Text(
                  'खाता खोलें >',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('कुल खर्च: ₹${_profileService.totalKharcha.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 12.sp, color: AppTheme.error, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    Text('कुल कमाई: ₹${_profileService.totalKamai.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 12.sp, color: AppTheme.success, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                onPressed: _showQuickVoiceModal,
                icon: const Icon(Icons.mic, size: 16, color: Colors.white),
                label: Text(
                  'बोलकर लिखें 🎙️',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts(List<ProductSummaryModel> products) {
    return SizedBox(
      height: 226.h,
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
            boxShadow: AppTheme.cardShadow,
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
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        offer.subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
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
                  width: 90.w,
                  height: 90.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90.w,
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
