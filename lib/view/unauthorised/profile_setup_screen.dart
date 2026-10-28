import 'package:shop/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'package:shop/services/language_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String mobileNumber;
  const ProfileSetupScreen({super.key, this.mobileNumber = ''});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  final _landController = TextEditingController();

  bool _saving = false;
  String _selectedLanguage = 'हिंदी (Hindi)';
  String _selectedDistrict = 'नीमच';

  final List<String> _languages = [
    'हिंदी (Hindi)',
    'English',
    'हिंग्लिश (Hinglish)',
  ];

  final List<String> _districts = [
    'नीमच',
    'मंदसौर',
    'इंदौर',
    'उज्जैन',
    'शाहजहांपुर',
    'कोटा',
    'करनाल',
  ];

  final List<Map<String, String>> _availableCrops = [
    {'name': 'गेहूं (Wheat)', 'icon': '🌾'},
    {'name': 'चना (Chana)', 'icon': '🌱'},
    {'name': 'सरसों (Mustard)', 'icon': '🌼'},
    {'name': 'सोयाबीन (Soyabean)', 'icon': '🌿'},
    {'name': 'धान (Paddy)', 'icon': '🌾'},
    {'name': 'लहसुन (Garlic)', 'icon': '🧄'},
    {'name': 'मक्का (Maize)', 'icon': '🌽'},
    {'name': 'कपास (Cotton)', 'icon': '☁️'},
  ];

  final Set<String> _selectedCrops = {'गेहूं (Wheat)', 'चना (Chana)'};

  @override
  void initState() {
    super.initState();
    final profile = FarmerProfileService();
    _nameController.text = profile.name;
    if (profile.isProfileCompleted) {
      _villageController.text = profile.village;
      _landController.text = profile.landArea;
      _selectedDistrict = profile.district;
      _selectedLanguage = profile.language;
      _selectedCrops
        ..clear()
        ..addAll(profile.selectedCrops);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _villageController.dispose();
    _landController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('कृपया अपना नाम दर्ज करें')));
      return;
    }

    if (_villageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('अपना गांव दर्ज करें')));
      return;
    }
    if (_selectedCrops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कम से कम एक मुख्य फसल चुनें')),
      );
      return;
    }

    if (_saving) return;
    setState(() => _saving = true);
    final service = FarmerProfileService();
    try {
      await AuthService.instance.updateProfile({
        'name': _nameController.text.trim(),
        'phone': service.phone,
        'village': _villageController.text.trim(),
        'district': _selectedDistrict,
        'state': service.state,
        'language': _selectedLanguage,
        'landArea': _landController.text.trim(),
        'selectedCrops': _selectedCrops.toList(),
      });
      service.applyServerProfile(AuthService.instance.user!.profile);
      await service.flush();
      await LanguageService.instance.changeLanguage(
        _selectedLanguage.contains('English') ? 'en' : 'hi',
      );
    } on Object catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      return;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'प्रोफ़ाइल सफलतापूर्वक सेट हो गई! स्वागत है किसान साथी में 🎉',
        ),
        backgroundColor: AppTheme.success,
      ),
    );

    Navigator.pushReplacementNamed(context, RoutesName.bottom_bar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('किसान प्रोफ़ाइल सेटअप'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('🌾', style: TextStyle(fontSize: 26.sp)),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'चरण 2: किसान विवरण',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'गाँव, फसल व भाषा चुनें',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'ताकि आपको रोज़ सटीक मौसम, मंडी भाव व सलाह मिले',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // 1. Language Selection (भाषा)
              _buildSectionTitle(
                '1. अपनी पसंदीदा भाषा चुनें (Select Language)',
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 8.h,
                children: _languages.map((lang) {
                  final isSelected = _selectedLanguage == lang;
                  return ChoiceChip(
                    label: Text(lang),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor.withValues(
                      alpha: 0.15,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : const Color(0xFFDCDCDC),
                      width: isSelected ? 1.5 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13.sp,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedLanguage = lang);
                      }
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20.h),

              // 2. Farmer Name & Mobile
              _buildSectionTitle('2. किसान का नाम व मोबाइल'),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'पूरा नाम (Full Name)',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppTheme.primaryColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: Colors.grey[600],
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            FarmerProfileService().phone.isEmpty
                                ? 'नंबर नहीं जोड़ा गया'
                                : FarmerProfileService().phone,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12.sp,
                                  color: AppTheme.success,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'संपर्क नंबर',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.success,
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
              ),

              SizedBox(height: 20.h),

              // 3. Location (District & Village / Zila & Gaon)
              _buildSectionTitle('3. जिला व गाँव चुनें (District & Village)'),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'जिला चुनें (Select District):',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _districts.map((dist) {
                        final isSel = _selectedDistrict == dist;
                        return ChoiceChip(
                          label: Text(dist),
                          selected: isSel,
                          selectedColor: AppTheme.primaryColor.withValues(
                            alpha: 0.15,
                          ),
                          backgroundColor: const Color(0xFFF7F7F7),
                          side: BorderSide(
                            color: isSel
                                ? AppTheme.primaryColor
                                : const Color(0xFFE0E0E0),
                          ),
                          labelStyle: TextStyle(
                            color: isSel
                                ? AppTheme.primaryColor
                                : AppTheme.textPrimary,
                            fontWeight: isSel
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12.sp,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedDistrict = dist);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12.h),
                    const Divider(height: 1),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _villageController,
                      decoration: const InputDecoration(
                        labelText: 'गाँव का नाम (Village Name)',
                        prefixIcon: Icon(
                          Icons.home_outlined,
                          color: AppTheme.primaryColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    const Divider(height: 1),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _landController,
                      decoration: const InputDecoration(
                        labelText:
                            'जमीन का क्षेत्रफल (Land Area, e.g. 4.5 एकड़)',
                        prefixIcon: Icon(
                          Icons.landscape_outlined,
                          color: AppTheme.primaryColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // 4. Primary Crops (फसल)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('4. मुख्य फसलें (Select Crops)'),
                  Text(
                    '${_selectedCrops.length} चुनी गई',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _availableCrops.map((crop) {
                  final name = crop['name']!;
                  final icon = crop['icon']!;
                  final isSelected = _selectedCrops.contains(name);
                  return FilterChip(
                    avatar: Text(icon, style: TextStyle(fontSize: 14.sp)),
                    label: Text(name),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor.withValues(
                      alpha: 0.18,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : const Color(0xFFDCDCDC),
                      width: isSelected ? 1.5 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedCrops.add(name);
                        } else {
                          if (_selectedCrops.length > 1) {
                            _selectedCrops.remove(name);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 30.h),

              // Save & Proceed Button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _saving ? null : _saveProfile,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ऐप में प्रवेश करें (Proceed to App)',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }
}
