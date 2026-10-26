import 'package:flutter/material.dart';
import 'package:shop/view/desktop/authoriwed/dashboard/widgets/low_stock_section.dart';
import 'package:shop/view/desktop/authoriwed/dashboard/widgets/order_status_section.dart';
import 'package:shop/view/desktop/authoriwed/dashboard/widgets/recent_orders_section.dart';
import 'package:shop/view/desktop/authoriwed/dashboard/widgets/sales_overview_section.dart';
import 'package:shop/view/desktop/authoriwed/dashboard/widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Stat card data ────────────────────────────────────────────────────
  static const _statCards = [
    {
      'icon': Icons.shopping_bag_outlined,
      'iconBg': Color(0xFFE8F5E9),
      'iconColor': Color(0xFF2E7D32),
      'title': 'Total Orders',
      'value': '1,248',
      'change': '+12.5% from last week',
      'waveColor': Color(0xFF2E7D32),
      'wave': [30.0, 45.0, 38.0, 55.0, 42.0, 60.0, 52.0],
    },
    {
      'icon': Icons.currency_rupee_rounded,
      'iconBg': Color(0xFFE8F5E9),
      'iconColor': Color(0xFF00897B),
      'title': 'Total Revenue',
      'value': '₹2,45,850',
      'change': '+18.6% from last week',
      'waveColor': Color(0xFF00897B),
      'wave': [20.0, 35.0, 28.0, 50.0, 44.0, 58.0, 62.0],
    },
    {
      'icon': Icons.people_outline_rounded,
      'iconBg': Color(0xFFEDE7F6),
      'iconColor': Color(0xFF6A1B9A),
      'title': 'Total Customers',
      'value': '856',
      'change': '+8.2% from last week',
      'waveColor': Color(0xFF6A1B9A),
      'wave': [40.0, 30.0, 50.0, 35.0, 55.0, 45.0, 60.0],
    },
    {
      'icon': Icons.inventory_2_outlined,
      'iconBg': Color(0xFFFFF3E0),
      'iconColor': Color(0xFFE65100),
      'title': 'Total Products',
      'value': '128',
      'change': '+5 from last week',
      'waveColor': Color(0xFFF9A825),
      'wave': [25.0, 40.0, 32.0, 48.0, 36.0, 52.0, 44.0],
    },
    {
      'icon': Icons.bar_chart_rounded,
      'iconBg': Color(0xFFE3F2FD),
      'iconColor': Color(0xFF1565C0),
      'title': 'Total Sales',
      'value': '₹1,75,600',
      'change': '+7.3% from last week',
      'waveColor': Color(0xFF1565C0),
      'wave': [35.0, 48.0, 40.0, 58.0, 46.0, 62.0, 55.0],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          color: const Color(0xFFF5F6FA),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stat Cards ──
                _buildStatCards(),
                const SizedBox(height: 24),

                // ── Sales Overview + Order Status ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 6, child: SalesOverviewSection()),
                    SizedBox(width: 20),
                    Expanded(flex: 4, child: OrderStatusSection()),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Recent Orders + Low Stock ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 6, child: RecentOrdersSection()),
                    SizedBox(width: 20),
                    Expanded(flex: 4, child: LowStockSection()),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: List.generate(_statCards.length, (i) {
        final c = _statCards[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < _statCards.length - 1 ? 16 : 0),
            child: _AnimatedStatCard(
              delay: Duration(milliseconds: 80 * i),
              child: StatCard(
                icon: c['icon'] as IconData,
                iconBg: c['iconBg'] as Color,
                iconColor: c['iconColor'] as Color,
                title: c['title'] as String,
                value: c['value'] as String,
                change: c['change'] as String,
                waveColor: c['waveColor'] as Color,
                waveData: (c['wave'] as List)
                    .map((e) => (e as num).toDouble())
                    .toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Staggered fade+slide for each stat card
class _AnimatedStatCard extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _AnimatedStatCard({required this.child, required this.delay});

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}
