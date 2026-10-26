import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/theme/app_theme.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width ?? 64.w,
            height: height ?? 64.w,
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
                  color: iconBackgroundColor ?? AppTheme.primaryLight.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppTheme.primaryColor,
                  size: 22.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            label,
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
}
