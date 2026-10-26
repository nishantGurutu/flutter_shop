import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/navigation/navigatin_event.dart';
import 'package:shop/bloc/navigation/navigation_bloc.dart';
import 'package:shop/bloc/navigation/navigation_state.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const _bg = Color(0xFF1A3A28);

  static const _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.receipt_long_rounded, 'label': 'Orders'},
    {'icon': Icons.inventory_2_rounded, 'label': 'Products'},
    {'icon': Icons.category_rounded, 'label': 'Categories'},
    {'icon': Icons.people_rounded, 'label': 'Customers'},
    {'icon': Icons.warehouse_rounded, 'label': 'Inventory'},
    {'icon': Icons.swap_horiz_rounded, 'label': 'Stock Requests'},
    {'icon': Icons.bar_chart_rounded, 'label': 'Reports'},
    {'icon': Icons.star_rounded, 'label': 'Reviews'},
    {'icon': Icons.local_offer_rounded, 'label': 'Coupons'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Container(
          color: _bg,
          child: Column(
            children: [
              _buildLogo(),
              const Divider(color: Colors.white24, thickness: 1, height: 1),
              const SizedBox(height: 6),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: List.generate(_navItems.length, (i) {
                      return _NavItem(
                        icon: _navItems[i]['icon'] as IconData,
                        label: _navItems[i]['label'] as String,
                        index: i,
                        activeIndex: state.index,
                      );
                    }),
                  ),
                ),
              ),
              _buildPremiumCard(),
              const SizedBox(height: 10),
              _buildLogout(context),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.green.shade500,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Krishi Saathi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Text('Fertilizer Store',
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF254535),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_rounded,
                  color: Colors.amber, size: 18),
              SizedBox(width: 6),
              Text('Premium Plan',
                  style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Your plan is active',
              style: TextStyle(color: Colors.white60, fontSize: 11)),
          const Text('Valid till: 25 Dec 2026',
              style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1A3A28),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Upgrade Plan',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return ListTile(
      dense: true,
      leading:
          const Icon(Icons.logout_rounded, color: Colors.white60, size: 20),
      title: const Text('Logout',
          style: TextStyle(color: Colors.white70, fontSize: 13)),
      onTap: () {},
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int activeIndex;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2E7D32) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon,
            color: isActive ? Colors.white : Colors.white60, size: 20),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () =>
            context.read<NavigationBloc>().add(ChangeTabEvent(index)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
