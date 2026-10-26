import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/bloc/home_bloc/home_bloc.dart';
import 'package:shop/bloc/order_bloc/order_bloc.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/repository/home_api/home_repository.dart';
import 'package:shop/view/authorised/advise/advice_screen.dart';
import 'package:shop/view/authorised/home/home_screen.dart';
import 'package:shop/view/authorised/order/order_screen.dart';
import 'package:shop/dependency_injection/locator.dart';
import 'package:shop/view/authorised/profile_screen/profile_screen.dart';
import 'package:shop/view/authorised/store/store.dart';

class BottomBarScreen extends StatelessWidget {
  const BottomBarScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    StoreScreen(),
    OrderScreen(),
    AdviceScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = const [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
    {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view, 'label': 'Shop'},
    {'icon': Icons.receipt_long_outlined, 'activeIcon': Icons.receipt_long, 'label': 'Orders'},
    {'icon': Icons.support_agent_outlined, 'activeIcon': Icons.support_agent, 'label': 'Advisory'},
    {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
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
      child: BlocBuilder<BottomBarBloc, BottomBarState>(
        builder: (context, state) {
          return Scaffold(
            body: _screens[state.currentIndex],
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
                    children: List.generate(_navItems.length, (index) {
                      final isSelected = state.currentIndex == index;
                      final item = _navItems[index];
                      return GestureDetector(
                        onTap: () {
                          context.read<BottomBarBloc>().add(BottomBarTabChanged(index));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                                isSelected ? item['activeIcon'] : item['icon'],
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textHint,
                                size: 24.sp,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item['label'],
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
      ),
    );
  }
}
