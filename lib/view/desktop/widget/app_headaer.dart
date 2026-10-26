import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Title
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A))),
              Text('Welcome back, Ram Kishan 👋',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),

          // Search
          Container(
            width: 220,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Icon(Icons.search, size: 17, color: Colors.grey),
                SizedBox(width: 8),
                Text('Search anything...',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Date Range
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey),
                SizedBox(width: 8),
                Text('Apr 25, 2026 - May 01, 2026',
                    style:
                        TextStyle(fontSize: 12, color: Color(0xFF444444))),
                SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Notification bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    size: 20, color: Colors.grey),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('5',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // User Avatar + Name
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.green.shade300,
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ram Kishan',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('Admin',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}