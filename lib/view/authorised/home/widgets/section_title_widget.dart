import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTapMore;

  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.onTapMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2843), // Dark text color
          ),
        ),
        GestureDetector(
          onTap: onTapMore,
          child: const Row(
            children: [
              Text(
                'More ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0052CC), // Blue accent
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xFF0052CC),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
