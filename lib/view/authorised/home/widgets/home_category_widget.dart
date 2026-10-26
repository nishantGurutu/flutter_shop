import 'package:flutter/material.dart';

class HomeCategoryWidget extends StatelessWidget {
  const HomeCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': Icons.lightbulb_outline,
        'name': 'Electrician',
        'color': Colors.orange,
      },
      {'icon': Icons.plumbing, 'name': 'Plumber', 'color': Colors.blue},
      {
        'icon': Icons.cleaning_services,
        'name': 'Cleaning',
        'color': Colors.green,
      },
      {
        'icon': Icons.ac_unit,
        'name': 'AC Repair',
        'color': Colors.grey.shade700,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'professional_list_screen',
                  arguments: category['name'],
                );
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category['name'] as String,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E3E5C),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
