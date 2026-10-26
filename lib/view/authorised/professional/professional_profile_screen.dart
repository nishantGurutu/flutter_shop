import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/professional_profile_bloc/professional_profile_bloc.dart';
import 'package:shop/config/color/app_color.dart';
import 'package:shop/model/professional/professional_model.dart';
import 'package:shop/config/routes/routes_name.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  final ProfessionalModel professional;
  const ProfessionalProfileScreen({super.key, required this.professional});

  @override
  State<ProfessionalProfileScreen> createState() => _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfessionalProfileBloc>().add(LoadProfessionalProfileEvent(widget.professional));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfessionalProfileBloc, ProfessionalProfileState>(
      builder: (context, state) {
        if (state.isLoading || state.professional == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final prof = state.professional!;
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context, prof),
                      _buildDetails(prof),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(context, prof),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ProfessionalModel prof) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 220.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF1E50CE),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              image: DecorationImage(
                image: NetworkImage(prof.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(ProfessionalModel prof) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      prof.name,
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            prof.rating.toString(),
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.darkText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  prof.title,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${prof.rating}',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    SizedBox(width: 8.w),
                    Row(
                      children: List.generate(5, (index) => Icon(Icons.star, color: index < prof.rating.floor() ? Colors.amber : Colors.grey.shade300, size: 18.sp)),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${prof.reviewsCount} Reviews',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Services Offered',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          SizedBox(height: 12.h),
          _buildServicesList(prof.servicesOffered),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
              Icon(Icons.more_horiz, color: Colors.grey.shade500),
            ],
          ),
          SizedBox(height: 12.h),
          _buildPortfolioGrid(prof.portfolioImages),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<String> services) {
    if (services.isEmpty) {
      return Text("No specific services listed.", style: TextStyle(color: Colors.grey.shade600));
    }
    return Column(
      children: services.map((service) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.build_circle, color: const Color(0xFF1E50CE), size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    service,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.darkText, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16.sp),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPortfolioGrid(List<String> images) {
    if (images.isEmpty) {
      return Text("No portfolio images.", style: TextStyle(color: Colors.grey.shade600));
    }
    return Row(
      children: images.take(3).map((img) {
        return Expanded(
          child: Container(
            height: 90.h,
            margin: EdgeInsets.only(right: images.last == img ? 0 : 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: NetworkImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(BuildContext context, ProfessionalModel prof) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.bookAppointment, arguments: prof);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E50CE),
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Book Appointment',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
