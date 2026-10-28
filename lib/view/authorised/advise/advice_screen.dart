import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/advisory_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;
import 'package:shop/view/widgets/common/section_header.dart';

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  late Future<AdvisoryModel> _advisoryFuture;

  @override
  void initState() {
    super.initState();
    _advisoryFuture = JsonDataService.loadAdvisory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Krishi Sathi'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<AdvisoryModel>(
        future: _advisoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

          if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load advisory data',
              onRetry: () {
                setState(() {
                  _advisoryFuture = JsonDataService.loadAdvisory();
                });
              },
            );
          }

          final advisory = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weather Card
                  _buildWeatherCard(advisory.weather),
                  SizedBox(height: 20.h),
                  // Smart Tips
                  SectionHeader(title: 'Smart Suggestions'),
                  SizedBox(height: 12.h),
                  ...advisory.smartTips.map((tip) => _buildSmartTipCard(tip)),
                  SizedBox(height: 20.h),
                  // Expert Categories
                  SectionHeader(title: 'Expert Consultation'),
                  SizedBox(height: 12.h),
                  _buildExpertCategories(advisory.expertCategories),
                  SizedBox(height: 20.h),
                  // FAQ Section
                  SectionHeader(title: 'Frequently Asked Questions'),
                  SizedBox(height: 12.h),
                  ...advisory.faq.map((faq) => _buildFaqItem(faq)),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherCard(WeatherDataModel weather) {
    IconData getWeatherIcon(String condition) {
      switch (condition.toLowerCase()) {
        case 'sunny':
          return Icons.wb_sunny;
        case 'cloudy':
          return Icons.wb_cloudy;
        case 'rainy':
          return Icons.water_drop;
        default:
          return Icons.wb_sunny;
      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppTheme.weatherGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather Info',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '${weather.temperature}°C',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    weather.condition,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              Icon(
                getWeatherIcon(weather.condition),
                size: 70.sp,
                color: Colors.white.withOpacity(0.9),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail('Humidity', '${weather.humidity}%', Icons.water_drop),
              _buildWeatherDetail('Wind', '${weather.windSpeed} km/h', Icons.air),
              _buildWeatherDetail('Location', weather.location, Icons.location_on),
            ],
          ),
          SizedBox(height: 20.h),
          // Forecast
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weather.forecast.map((day) {
              return _buildForecastDay(day);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20.sp),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastDay(ForecastDayModel day) {
    return Column(
      children: [
        Text(
          day.day,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 6.h),
        Icon(
          day.condition == 'sunny'
              ? Icons.wb_sunny
              : day.condition == 'cloudy'
                  ? Icons.wb_cloudy
                  : Icons.water_drop,
          color: Colors.white,
          size: 20.sp,
        ),
        SizedBox(height: 6.h),
        Text(
          '${day.temp}°',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSmartTipCard(SmartTipModel tip) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  tip.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    tip.buttonText,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              tip.image,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertCategories(List<ExpertCategoryModel> categories) {
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'local_hospital':
          return Icons.local_hospital;
        case 'terrain':
          return Icons.terrain;
        case 'bug_report':
          return Icons.bug_report;
        case 'wb_sunny':
          return Icons.wb_sunny;
        default:
          return Icons.person;
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Color(int.parse(category.color.replaceAll('#', '0xFF')))
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getIcon(category.icon),
                    color: Color(int.parse(category.color.replaceAll('#', '0xFF'))),
                    size: 26.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFaqItem(FaqModel faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Text(
              faq.answer,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
