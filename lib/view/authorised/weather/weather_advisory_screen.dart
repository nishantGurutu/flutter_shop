import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/weather_advisory_model.dart';
import 'package:shop/services/farmer_profile_service.dart';

class WeatherAdvisoryScreen extends StatefulWidget {
  const WeatherAdvisoryScreen({super.key});

  @override
  State<WeatherAdvisoryScreen> createState() => _WeatherAdvisoryScreenState();
}

class _WeatherAdvisoryScreenState extends State<WeatherAdvisoryScreen> {
  final _service = FarmerProfileService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_refresh);
    _service.refreshFeed();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _service.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final advisory = _service.weatherAdvisory;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _service.hasLiveFeed ? 'मौसम व सीधी सलाह' : 'मौसम व सलाह • Demo',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'यह उदाहरण मौसम है। Live provider अभी connect नहीं है।',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_service.feedStatus),
            ),
            // Top Main Weather Hero Card
            _buildWeatherHeroCard(advisory),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Direct Spray Advisory (स्प्रे की सीधी सलाह)
                  _buildSprayAdvisoryCard(advisory),

                  SizedBox(height: 16.h),

                  // 2. Direct Irrigation Advisory (सिंचाई सलाह)
                  _buildIrrigationCard(advisory),

                  SizedBox(height: 20.h),

                  // 3. Hourly Spray Timeline (घंटे अनुसार स्प्रे स्थिति)
                  _buildSectionHeader(
                    'घंटे अनुसार स्प्रे स्थिति (Hourly Feasibility)',
                    Icons.access_time,
                  ),
                  SizedBox(height: 10.h),
                  _buildHourlyTimeline(advisory.hourlyForecasts),

                  SizedBox(height: 20.h),

                  // 4. Crop Specific Spray Guidance (फसल अनुसार सही दवा व मात्रा)
                  _buildSectionHeader(
                    'फसल अनुसार स्प्रे सलाह (Crop Spray Tips)',
                    Icons.grass,
                  ),
                  SizedBox(height: 10.h),
                  _buildCropSprayList(advisory.cropSprayTips),

                  SizedBox(height: 20.h),

                  // 5. 7-Day Forecast (7 दिनों का पूर्वानुमान)
                  _buildSectionHeader(
                    '7 दिनों का मौसम पूर्वानुमान (7-Day Forecast)',
                    Icons.calendar_month,
                  ),
                  SizedBox(height: 10.h),
                  _buildDailyForecastList(advisory.dailyForecasts),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHeroCard(WeatherAdvisoryModel advisory) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: const BoxDecoration(
        gradient: AppTheme.weatherGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 18),
                  SizedBox(width: 4.w),
                  Text(
                    '${_service.district}, ${_service.state}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Live IMD Data',
                      style: TextStyle(color: Colors.white, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${advisory.temperature}°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    advisory.condition,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'अधिकतम ${advisory.highTemp}° / न्यूनतम ${advisory.lowTemp}°',
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                ],
              ),
              Icon(
                Icons.wb_sunny_rounded,
                color: const Color(0xFFFFD54F),
                size: 72.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherStat(
                  Icons.water_drop_outlined,
                  '${advisory.humidity}%',
                  'नमी (Humidity)',
                ),
                Container(height: 24.h, width: 1, color: Colors.white30),
                _buildWeatherStat(
                  Icons.air,
                  '${advisory.windSpeed} km/h',
                  'हवा (Wind)',
                ),
                Container(height: 24.h, width: 1, color: Colors.white30),
                _buildWeatherStat(
                  Icons.umbrella_outlined,
                  '${advisory.rainProbability}%',
                  'बारिश (Rain)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildSprayAdvisoryCard(WeatherAdvisoryModel advisory) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.success.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sanitizer,
                      color: AppTheme.success,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'आज की स्प्रे सलाह',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'अनुकूल (Safe)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            advisory.sprayAdviceTitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryDark,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            advisory.sprayAdviceDescription,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.alarm_on,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'सर्वोत्तम समय: ${advisory.bestSprayWindow}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIrrigationCard(WeatherAdvisoryModel advisory) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF0288D1).withValues(alpha: 0.3),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF0288D1),
                  size: 20,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'सिंचाई की सीधी सलाह',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            advisory.irrigationAdviceTitle,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF01579B),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            advisory.irrigationAdviceDescription,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyTimeline(List<HourlyForecast> hours) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final h = hours[index];
          final isSafe = h.spraySuitability == SpraySuitability.safe;
          return Container(
            width: 95.w,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSafe
                    ? AppTheme.success.withValues(alpha: 0.4)
                    : AppTheme.warning.withValues(alpha: 0.4),
              ),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  h.time,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '${h.temp}°C',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSafe
                        ? AppTheme.success.withValues(alpha: 0.15)
                        : AppTheme.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isSafe ? 'स्प्रे ✅' : 'सावधानी ⚠️',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: isSafe ? AppTheme.success : AppTheme.warning,
                    ),
                  ),
                ),
                Text(
                  '${h.windSpeed} km/h हवा',
                  style: TextStyle(fontSize: 10.sp, color: AppTheme.textHint),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCropSprayList(List<CropSprayTip> tips) {
    return Column(
      children: tips.map((tip) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tip.cropHindi,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      tip.pestOrDisease,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'दवा: ${tip.medicine}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'मात्रा: ${tip.dosage}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'सलाह: ${tip.recommendation}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyForecastList(List<DailyForecast> days) {
    return Column(
      children: days.map((day) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.day,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      day.date,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      day.rainChance > 30
                          ? Icons.water_drop
                          : Icons.wb_sunny_outlined,
                      size: 16.sp,
                      color: day.rainChance > 30
                          ? const Color(0xFF0288D1)
                          : AppTheme.secondaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${day.rainChance}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${day.highTemp}° / ${day.lowTemp}°',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: day.spraySuitability == SpraySuitability.safe
                      ? AppTheme.success.withValues(alpha: 0.15)
                      : (day.spraySuitability == SpraySuitability.caution
                            ? AppTheme.warning.withValues(alpha: 0.15)
                            : AppTheme.error.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  day.spraySuitability == SpraySuitability.safe
                      ? 'स्प्रे करें'
                      : (day.spraySuitability == SpraySuitability.caution
                            ? 'सावधानी'
                            : 'स्प्रे रोकें'),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: day.spraySuitability == SpraySuitability.safe
                        ? AppTheme.success
                        : (day.spraySuitability == SpraySuitability.caution
                              ? AppTheme.warning
                              : AppTheme.error),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppTheme.primaryColor),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
