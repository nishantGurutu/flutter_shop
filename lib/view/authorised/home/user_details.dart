import 'package:shop/config/color/app_color.dart';
import 'package:shop/model/home/home_model.dart';
import 'package:shop/utils/extensions/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetails extends StatefulWidget {
  final UserModel user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [_headerImage(context), _userDetailsSection(context)],
        ),
      ),
    );
  }

  Widget _headerImage(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400.h,
          width: double.infinity,
          child: Image.network(widget.user.imageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          top: 40.h,
          left: 15.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18.r,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _userDetailsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.user.name} , ${widget.user.age}",
                style: context.h1.copyWith(color: AppColors.darkText),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Icon(Icons.business_center, color: Colors.grey, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    widget.user.role,
                    style: context.body.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                "About",
                style: context.boldBody.copyWith(color: AppColors.darkText),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.user.about,
                style: context.bodySmall.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Interest",
                style: context.boldBody.copyWith(color: AppColors.darkText),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 10.h,
                children: widget.user.interests.map((interest) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      interest,
                      style: context.bodySmall.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 50.h),
            ],
          ),
          Positioned(
            right: 0,
            top: -20.h,
            child: Column(
              children: [
                _actionButton(Icons.check, [
                  const Color(0xFFB56AFF),
                  const Color(0xFF8F4CFF),
                ]),
                SizedBox(height: 15.h),
                _actionButton(Icons.star, [
                  const Color(0xFFB56AFF),
                  const Color(0xFF8F4CFF),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, List<Color> colors) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 24.sp),
    );
  }
}
