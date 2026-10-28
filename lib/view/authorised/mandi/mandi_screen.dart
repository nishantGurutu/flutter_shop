import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/mandi_model.dart';
import 'package:shop/services/farmer_profile_service.dart';

class MandiScreen extends StatefulWidget {
  const MandiScreen({super.key});

  @override
  State<MandiScreen> createState() => _MandiScreenState();
}

class _MandiScreenState extends State<MandiScreen> with SingleTickerProviderStateMixin {
  final _service = FarmerProfileService();
  String _selectedCropFilter = 'सभी (All)';
  late TabController _tabController;

  final List<String> _cropFilters = [
    'सभी (All)',
    'गेहूं (Wheat)',
    'चना (Gram)',
    'सरसों (Mustard)',
    'सोयाबीन (Soyabean)',
    'लहसुन (Garlic)',
    'धान (Paddy)',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _tabController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _showAddRateAlertDialog() {
    String selectedCrop = 'गेहूं';
    String cropEnglish = 'Wheat';
    double targetPrice = 2700;
    final priceController = TextEditingController(text: '2700');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_alert, color: AppTheme.secondaryColor),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'नया रेट अलर्ट लगाएं',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'जब मंडी में फसल का भाव आपके तय भाव पर पहुँचेगा, आपको तुरंत सूचना मिलेगी।',
                    style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
                  ),
                  SizedBox(height: 16.h),

                  // Crop Selector
                  Text('फसल चुनें (Crop):', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: ['गेहूं', 'चना', 'सरसों', 'सोयाबीन', 'लहसुन'].map((c) {
                      final isSel = selectedCrop == c;
                      return ChoiceChip(
                        label: Text(c),
                        selected: isSel,
                        selectedColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: isSel ? AppTheme.primaryColor : AppTheme.textPrimary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setModalState(() {
                              selectedCrop = c;
                              if (c == 'गेहूं') {
                                cropEnglish = 'Wheat';
                                priceController.text = '2750';
                              } else if (c == 'चना') {
                                cropEnglish = 'Gram';
                                priceController.text = '6000';
                              } else if (c == 'सरसों') {
                                cropEnglish = 'Mustard';
                                priceController.text = '5800';
                              } else if (c == 'सोयाबीन') {
                                cropEnglish = 'Soyabean';
                                priceController.text = '4800';
                              } else if (c == 'लहसुन') {
                                cropEnglish = 'Garlic';
                                priceController.text = '16500';
                              }
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16.h),

                  // Target Price Input
                  Text('लक्ष्य भाव (Target Price ₹/क्विंटल):', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      suffixText: '/ क्विंटल',
                      hintText: '2700',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      onPressed: () {
                        targetPrice = double.tryParse(priceController.text) ?? 2700;
                        final newAlert = RateAlertModel(
                          id: 'ra_${DateTime.now().millisecondsSinceEpoch}',
                          cropName: cropEnglish,
                          cropHindi: selectedCrop,
                          mandiName: _service.selectedMandi,
                          targetPrice: targetPrice,
                          isAbove: true,
                          isActive: true,
                          createdAt: 'आज',
                        );
                        _service.addRateAlert(newAlert);
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$selectedCrop के लिए ₹$targetPrice का रेट अलर्ट सेट किया गया!'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      },
                      child: Text(
                        'रेट अलर्ट सेट करें (Set Alert)',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('मंडी भाव व रेट अलर्ट'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert, color: AppTheme.secondaryColor),
            tooltip: 'रेट अलर्ट लगाएं',
            onPressed: _showAddRateAlertDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primaryColor,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront, size: 18),
                  SizedBox(width: 6.w),
                  const Text('मंडी भाव (Rates)'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_active_outlined, size: 18),
                  SizedBox(width: 6.w),
                  Text('रेट अलर्ट (${_service.rateAlerts.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMandiRatesTab(),
          _buildRateAlertsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: Text(
          'रेट अलर्ट लगाएं',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
        onPressed: _showAddRateAlertDialog,
      ),
    );
  }

  Widget _buildMandiRatesTab() {
    final filteredRates = _selectedCropFilter == 'सभी (All)'
        ? _service.mandiRates
        : _service.mandiRates.where((r) {
            final f = _selectedCropFilter.toLowerCase();
            return r.cropHindi.toLowerCase().contains(f.split(' ')[0]) ||
                r.cropName.toLowerCase().contains(f.split(' ')[0]);
          }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mandi Selector Card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_city, color: AppTheme.primaryColor, size: 20),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'मंडी चुनें (Select Mandi)',
                        style: TextStyle(fontSize: 11.sp, color: AppTheme.textHint),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _service.selectedMandi,
                          isDense: true,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          items: _service.availableMandis.map((m) {
                            return DropdownMenuItem<String>(value: m, child: Text(m));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) _service.selectMandi(val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Agmarknet',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTheme.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Crop Filter Chips
          SizedBox(
            height: 38.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cropFilters.length,
              itemBuilder: (context, index) {
                final filter = _cropFilters[index];
                final isSelected = _selectedCropFilter == filter;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryColor : const Color(0xFFE0E0E0),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCropFilter = filter);
                    },
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 14.h),

          // Rates Cards List
          ...filteredRates.map((rate) => _buildMandiRateCard(rate)),

          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget _buildMandiRateCard(MandiRateModel rate) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Crop Name & Price Trend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rate.cropHindi,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'किस्म: ${rate.variety} • आवक: ${rate.arrival}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: rate.isUp
                      ? AppTheme.success.withValues(alpha: 0.12)
                      : (rate.isDown ? AppTheme.error.withValues(alpha: 0.12) : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      rate.isUp
                          ? Icons.arrow_upward_rounded
                          : (rate.isDown ? Icons.arrow_downward_rounded : Icons.remove),
                      size: 14.sp,
                      color: rate.isUp ? AppTheme.success : (rate.isDown ? AppTheme.error : Colors.grey[600]),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '₹${rate.priceChange.abs().toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: rate.isUp ? AppTheme.success : (rate.isDown ? AppTheme.error : Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Price Metrics Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8F5E9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriceMetric('न्यूनतम (Min)', '₹${rate.minPrice.toStringAsFixed(0)}', Colors.grey[800]!),
                Container(height: 30.h, width: 1, color: Colors.grey[300]),
                _buildPriceMetric('औसत (Modal)', '₹${rate.modalPrice.toStringAsFixed(0)}', AppTheme.primaryColor, isHighlighted: true),
                Container(height: 30.h, width: 1, color: Colors.grey[300]),
                _buildPriceMetric('अधिकतम (Max)', '₹${rate.maxPrice.toStringAsFixed(0)}', AppTheme.primaryDark),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          // Bottom Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${rate.mandiName} • ${rate.date}',
                style: TextStyle(fontSize: 11.sp, color: AppTheme.textHint),
              ),
              InkWell(
                onTap: () {
                  _showSetAlertForCrop(rate);
                },
                child: Row(
                  children: [
                    Icon(Icons.add_alert, size: 14.sp, color: AppTheme.secondaryColor),
                    SizedBox(width: 4.w),
                    Text(
                      'अलर्ट लगाएं',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSetAlertForCrop(MandiRateModel rate) {
    final alert = RateAlertModel(
      id: 'ra_${DateTime.now().millisecondsSinceEpoch}',
      cropName: rate.cropName,
      cropHindi: rate.cropHindi.split(' ')[0],
      mandiName: rate.mandiName,
      targetPrice: rate.modalPrice + 100,
      isAbove: true,
      isActive: true,
      createdAt: 'आज',
    );
    _service.addRateAlert(alert);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${rate.cropHindi} के लिए ₹${(rate.modalPrice + 100).toStringAsFixed(0)} का रेट अलर्ट सक्रिय!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  Widget _buildPriceMetric(String title, String price, Color color, {bool isHighlighted = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.textSecondary,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          price,
          style: TextStyle(
            fontSize: isHighlighted ? 17.sp : 14.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRateAlertsTab() {
    final alerts = _service.rateAlerts;

    if (alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 60.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              'कोई सक्रिय रेट अलर्ट नहीं है',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
            Text(
              'अपनी फसलों के लिए भाव अलर्ट लगाएं',
              style: TextStyle(fontSize: 13.sp, color: AppTheme.textSecondary),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: _showAddRateAlertDialog,
              icon: const Icon(Icons.add_alert, color: Colors.white),
              label: const Text('अलर्ट जोड़ें (Add Alert)', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: AppTheme.cardShadow,
            border: Border.all(
              color: alert.isActive
                  ? AppTheme.secondaryColor.withValues(alpha: 0.3)
                  : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: alert.isActive
                      ? AppTheme.secondaryColor.withValues(alpha: 0.15)
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: alert.isActive ? AppTheme.secondaryColor : Colors.grey[400],
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          alert.cropHindi,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '₹${alert.targetPrice.toStringAsFixed(0)}/क्विंटल',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${alert.mandiName} • भाव ऊपर जाने पर अलर्ट',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: alert.isActive,
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (_) => _service.toggleRateAlert(alert.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                onPressed: () => _service.removeRateAlert(alert.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
