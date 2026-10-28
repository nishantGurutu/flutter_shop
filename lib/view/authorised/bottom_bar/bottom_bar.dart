import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/bloc/home_bloc/home_bloc.dart';
import 'package:shop/bloc/order_bloc/order_bloc.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/dependency_injection/locator.dart';
import 'package:shop/services/language_service.dart';
import 'package:shop/utils/app_texts.dart';
import 'package:shop/view/authorised/home/home_screen.dart';
import 'package:shop/view/authorised/profile_screen/profile_screen.dart';
import 'package:shop/view/authorised/settings/settings_screen.dart';
import 'package:shop/view/authorised/store/store.dart';

class BottomBarScreen extends StatelessWidget {
  const BottomBarScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    StoreScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomBarBloc()),
        BlocProvider(
          create: (context) =>
              HomeBloc(homeRepository: getIt<HomeRepository>()),
        ),
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: ListenableBuilder(
        listenable: LanguageService.instance,
        builder: (context, _) {
          final navItems = [
            {
              'icon': Icons.home_outlined,
              'activeIcon': Icons.home,
              'label': AppTexts.tr('nav_home'),
            },
            {
              'icon': Icons.shopping_bag_outlined,
              'activeIcon': Icons.shopping_bag,
              'label': AppTexts.tr('nav_store'),
            },
            {
              'icon': Icons.person_outline,
              'activeIcon': Icons.person,
              'label': AppTexts.tr('nav_profile'),
            },
            {
              'icon': Icons.settings_outlined,
              'activeIcon': Icons.settings,
              'label': AppTexts.tr('nav_settings'),
            },
          ];

          return BlocBuilder<BottomBarBloc, BottomBarState>(
            builder: (context, state) {
              final selectedIndex = state.currentIndex.clamp(0, _screens.length - 1);

              return Scaffold(
                body: _screens[selectedIndex],
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(navItems.length, (index) {
                          final isSelected = selectedIndex == index;
                          final item = navItems[index];
                          return GestureDetector(
                            onTap: () {
                              context.read<BottomBarBloc>().add(BottomBarTabChanged(index));
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSelected
                                        ? (item['activeIcon'] as IconData)
                                        : (item['icon'] as IconData),
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.textHint,
                                    size: 24.sp,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item['label'] as String,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : AppTheme.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
