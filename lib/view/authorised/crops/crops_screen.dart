import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/crop_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  late Future<List<CropModel>> _cropsFuture;

  @override
  void initState() {
    super.initState();
    _cropsFuture = JsonDataService.loadCrops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Crops'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<CropModel>>(
        future: _cropsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

          if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load crops',
              onRetry: () {
                setState(() {
                  _cropsFuture = JsonDataService.loadCrops();
                });
              },
            );
          }

          final crops = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index];
              return _buildCropCard(crop);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCropCard(CropModel crop) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Header Image Section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            child: Stack(
              children: [
                Image.asset(
                  crop.image,
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120.h,
                      color: AppTheme.primaryLight.withOpacity(0.2),
                      child: Icon(
                        Icons.agriculture,
                        size: 50.sp,
                        color: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: Color(int.parse(crop.healthColor.replaceAll('#', '0xFF'))),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          crop.health,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crop.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          crop.nameHi,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${crop.area} ${crop.areaUnit}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          crop.stage,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${crop.stageProgress}%',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: crop.stageProgress / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Info Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'Sowing Date',
                        DateFormat('dd MMM yyyy').format(DateTime.parse(crop.sowingDate)),
                        Icons.calendar_today_outlined,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildInfoItem(
                        'Expected Harvest',
                        DateFormat('dd MMM yyyy').format(DateTime.parse(crop.expectedHarvest)),
                        Icons.event_available_outlined,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Next Activity
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        color: AppTheme.secondaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Activity',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              crop.nextActivity,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM').format(DateTime.parse(crop.nextActivityDate)),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: AppTheme.textHint,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTheme.textHint,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
