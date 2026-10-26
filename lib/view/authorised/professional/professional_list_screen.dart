import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/professional_list_bloc/professional_list_bloc.dart';
import 'package:shop/config/color/app_color.dart';
import 'package:shop/model/professional/professional_model.dart';
import 'package:shop/config/routes/routes_name.dart';

class ProfessionalListScreen extends StatefulWidget {
  final String category;
  const ProfessionalListScreen({super.key, required this.category});

  @override
  State<ProfessionalListScreen> createState() => _ProfessionalListScreenState();
}

class _ProfessionalListScreenState extends State<ProfessionalListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfessionalListBloc>().add(FetchProfessionalsEvent(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<ProfessionalListBloc, ProfessionalListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.professionals.isEmpty) {
                  return const Center(child: Text("No professionals found."));
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: state.professionals.length,
                  itemBuilder: (context, index) {
                    return _buildProfessionalCard(state.professionals[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkText, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.category,
        style: TextStyle(
          color: AppColors.darkText,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterChip('Sort', Icons.sort, isSelected: false),
          _buildFilterChip('Price', Icons.price_change_outlined, isSelected: false),
          _buildFilterChip('Rating', Icons.star_border, isSelected: false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {required bool isSelected}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: isSelected ? Colors.blue : Colors.grey.shade600),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.keyboard_arrow_down, size: 16.sp, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(ProfessionalModel professional) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.professionalProfile, arguments: professional);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                professional.imageUrl,
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        professional.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      Row(
                        children: List.generate(3, (index) => Icon(Icons.star, color: Colors.amber, size: 14.sp)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    professional.title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12.sp, color: Colors.green),
                          SizedBox(width: 4.w),
                          Text(
                            '${professional.distance} km',
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700),
                          ),
                          SizedBox(width: 10.w),
                          Icon(Icons.timer, size: 12.sp, color: Colors.blue),
                          SizedBox(width: 4.w),
                          Text(
                            professional.timeEstimate,
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.bookAppointment, arguments: professional);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E50CE),
                          minimumSize: Size(80.w, 32.h),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
