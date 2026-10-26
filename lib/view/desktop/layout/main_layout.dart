import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/navigation/navigation_bloc.dart';
import 'package:shop/bloc/navigation/navigation_state.dart';
import 'package:shop/view/desktop/authoriwed/dashboard/dashboard_screen.dart';
import 'package:shop/view/desktop/authoriwed/orders/orders_screen.dart';
import 'package:shop/view/desktop/authoriwed/products/products_screen.dart';
import 'package:shop/view/desktop/authoriwed/categories/categories_screen.dart';
import 'package:shop/view/desktop/authoriwed/customers/customers_screen.dart';
import 'package:shop/view/desktop/authoriwed/inventory/inventory_screen.dart';
import 'package:shop/view/desktop/authoriwed/stock_requests/stock_requests_screen.dart';
import 'package:shop/view/desktop/authoriwed/reports/reports_screen.dart';
import 'package:shop/view/desktop/authoriwed/reviews/reviews_screen.dart';
import 'package:shop/view/desktop/authoriwed/coupons/coupons_screen.dart';
import 'package:shop/view/desktop/authoriwed/settings/settings_screen.dart';
import 'package:shop/view/desktop/widget/app_footer.dart';
import 'package:shop/view/desktop/widget/app_headaer.dart';
import 'package:shop/view/desktop/widget/app_sidebar.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ──
          const SizedBox(width: 250, child: AppSidebar()),

          // ── Main area ──
          Expanded(
            child: Column(
              children: [
                // Header
                const SizedBox(height: 70, child: AppHeader()),

                // Page body
                Expanded(
                  child: BlocBuilder<NavigationBloc, NavigationState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: KeyedSubtree(
                          key: ValueKey<int>(state.index),
                          child: _getScreen(state.index),
                        ),
                      );
                    },
                  ),
                ),

                // Footer
                const SizedBox(height: 40, child: AppFooter()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const OrdersScreen();
      case 2:
        return const ProductsScreen();
      case 3:
        return const CategoriesScreen();
      case 4:
        return const CustomersScreen();
      case 5:
        return const InventoryScreen();
      case 6:
        return const StockRequestsScreen();
      case 7:
        return const ReportsScreen();
      case 8:
        return const ReviewsScreen();
      case 9:
        return const CouponsScreen();
      case 10:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }
}
