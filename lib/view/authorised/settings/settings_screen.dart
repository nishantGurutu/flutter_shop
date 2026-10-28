import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'package:shop/services/language_service.dart';
import 'package:shop/utils/app_texts.dart';
import 'package:shop/view/widgets/common/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _profileService = FarmerProfileService();
  final _langService = LanguageService.instance;

  bool _notifications = true;
  bool _weatherBulletin = true;
  bool _voiceAssistant = true;

  @override
  void initState() {
    super.initState();
    _profileService.addListener(_onServiceUpdate);
    _langService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _profileService.removeListener(_onServiceUpdate);
    _langService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _changeAppLanguage(String langCode) async {
    if (_langService.currentLanguage == langCode) return;
    await _langService.changeLanguage(langCode);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8.w),
              Text(
                langCode == 'hi'
                    ? 'भाषा बदलकर हिंदी कर दी गई है!'
                    : 'Language switched to English successfully!',
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showFaqModal() {
    final isHindi = _langService.isHindi;
    final faqs = isHindi
        ? [
            {
              'q': 'मंडी भाव कैसे चेक करें?',
              'a': 'होम स्क्रीन पर "मंडी भाव" विकल्प पर टैप करें। आप अपनी स्थानीय मंडी और फसल चुनकर ताज़ा भाव व आवक देख सकते हैं।',
            },
            {
              'q': 'खाते में बोलकर एंट्री कैसे करें?',
              'a': 'होम स्क्रीन या खाता स्क्रीन में माइक बटन दबाकर बोलें, जैसे "2 बोरी डीएपी 2700 रुपये"। ऐप अपने आप खर्च या कमाई समझकर जोड़ लेगा।',
            },
            {
              'q': 'स्प्रे सलाह का क्या मतलब है?',
              'a': 'मौसम के अनुसार हवा और बारिश की जांच करके ऐप बताता है कि आज दवा का छिड़काव सुरक्षित है या नहीं।',
            },
            {
              'q': 'रेट अलर्ट कैसे लगाएं?',
              'a': 'मंडी स्क्रीन पर जाकर अपनी मनपसंद फसल का लक्ष्य मूल्य सेट करें। भाव छूने पर आपको तुरंत नोटिफिकेशन मिलेगा।',
            },
          ]
        : [
            {
              'q': 'How to check Mandi Rates?',
              'a': 'Tap on "Mandi Rates" on the Home screen to view real-time prices and arrivals for your nearest markets.',
            },
            {
              'q': 'How to add voice entries in Khata?',
              'a': 'Tap the mic icon in Khata and speak naturally, e.g., "2 bags DAP 2700 rupees". The app automatically categorizes and logs it.',
            },
            {
              'q': 'What is Spray Advisory?',
              'a': 'Based on wind speed and rain forecast, the app advises whether it is safe or unsafe to spray pesticides today.',
            },
            {
              'q': 'How to set a Rate Alert?',
              'a': 'Go to the Mandi screen, choose your crop, and set a target price to get notified when prices match your expectation.',
            },
          ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppTexts.tr('faq_title'),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...faqs.map((faq) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FBF9),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.help_outline, color: AppTheme.primaryColor, size: 18),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    faq['q']!,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              faq['a']!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        content: Text(content, style: TextStyle(fontSize: 13.sp, color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTexts.tr('ok'), style: const TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(AppTexts.tr('logout_dialog_title'), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        content: Text(AppTexts.tr('logout_dialog_msg'), style: TextStyle(fontSize: 13.sp, color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTexts.tr('cancel'), style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
            },
            child: Text(AppTexts.tr('logout_btn'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = _langService.isHindi;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        title: Text(
          AppTexts.tr('settings_title'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────────
            // 1. Language Selection Card (भाषा चयन)
            // ─────────────────────────────────────────────────────────────
            _buildSectionHeader(
              title: AppTexts.tr('settings_language_section'),
              icon: Icons.language,
            ),
            SizedBox(height: 8.h),
            _buildLanguageCard(
              title: 'हिंदी (Hindi)',
              subtitle: AppTexts.tr('lang_hindi_sub'),
              flagEmoji: '🇮🇳',
              isSelected: isHindi,
              onTap: () => _changeAppLanguage('hi'),
            ),
            SizedBox(height: 8.h),
            _buildLanguageCard(
              title: 'English',
              subtitle: AppTexts.tr('lang_english_sub'),
              flagEmoji: '🇬🇧',
              isSelected: !isHindi,
              onTap: () => _changeAppLanguage('en'),
            ),

            SizedBox(height: 20.h),

            // ─────────────────────────────────────────────────────────────
            // 2. Farmer Profile Card
            // ─────────────────────────────────────────────────────────────
            _buildSectionHeader(
              title: AppTexts.tr('settings_profile_section'),
              icon: Icons.person_outline,
            ),
            SizedBox(height: 8.h),
            CustomCard(
              padding: EdgeInsets.all(14.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26.r,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.12),
                        child: Text(
                          _profileService.name.isNotEmpty ? _profileService.name[0] : 'K',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profileService.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              '${_profileService.phone} • ${_profileService.village}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${_profileService.district}, ${_profileService.state} • ${_profileService.landArea}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppTheme.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, RoutesName.profileSetup),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit_note, color: AppTheme.primaryColor, size: 18),
                          SizedBox(width: 6.w),
                          Text(
                            AppTexts.tr('edit_profile_btn'),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ─────────────────────────────────────────────────────────────
            // 3. App Preferences & Toggles
            // ─────────────────────────────────────────────────────────────
            _buildSectionHeader(
              title: AppTexts.tr('settings_pref_section'),
              icon: Icons.tune,
            ),
            SizedBox(height: 8.h),
            CustomCard(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primaryColor,
                    title: Text(
                      AppTexts.tr('pref_notifications'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      AppTexts.tr('pref_notifications_sub'),
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                    ),
                    value: _notifications,
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primaryColor,
                    title: Text(
                      AppTexts.tr('pref_weather_alerts'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      AppTexts.tr('pref_weather_alerts_sub'),
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                    ),
                    value: _weatherBulletin,
                    onChanged: (val) => setState(() => _weatherBulletin = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primaryColor,
                    title: Text(
                      AppTexts.tr('pref_voice_assistant'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      AppTexts.tr('pref_voice_assistant_sub'),
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                    ),
                    value: _voiceAssistant,
                    onChanged: (val) => setState(() => _voiceAssistant = val),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ─────────────────────────────────────────────────────────────
            // 4. Kisan Help & Support
            // ─────────────────────────────────────────────────────────────
            _buildSectionHeader(
              title: AppTexts.tr('settings_help_section'),
              icon: Icons.support_agent,
            ),
            SizedBox(height: 8.h),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call, color: AppTheme.primaryColor, size: 20),
                    ),
                    title: Text(
                      AppTexts.tr('kisan_helpline'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'टोल-फ्री: 1800-180-1551 (सुबह 6 AM - रात 10 PM)',
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        AppTexts.tr('call'),
                        style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      _showInfoDialog(
                        AppTexts.tr('kisan_helpline'),
                        'किसान कॉल सेंटर नंबर: 1800-180-1551 पर कॉल करें। कृषि विशेषज्ञ फसल, बीज और रोग संबंधित सहायता प्रदान करेंगे।',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat, color: Colors.teal, size: 20),
                    ),
                    title: Text(
                      AppTexts.tr('whatsapp_help'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      AppTexts.tr('whatsapp_help_desc'),
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textHint),
                    onTap: () {
                      _showInfoDialog(
                        AppTexts.tr('whatsapp_help'),
                        'व्हाट्सएप नंबर: +91 98765 43210 पर अपनी फसल का फोटो भेजकर डॉक्टर से निःशुल्क परामर्श पाएं।',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.quiz_outlined, color: Colors.amber, size: 20),
                    ),
                    title: Text(
                      AppTexts.tr('faq_title'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      AppTexts.tr('faq_desc'),
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textHint),
                    onTap: _showFaqModal,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ─────────────────────────────────────────────────────────────
            // 5. About & Legal
            // ─────────────────────────────────────────────────────────────
            _buildSectionHeader(
              title: AppTexts.tr('settings_about_section'),
              icon: Icons.info_outline,
            ),
            SizedBox(height: 8.h),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      AppTexts.tr('privacy_policy'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textHint),
                    onTap: () {
                      _showInfoDialog(
                        AppTexts.tr('privacy_policy'),
                        'किसान साथी आपकी निजी जानकारी व फसल डेटा की पूर्ण गोपनीयता बनाए रखता है। आपका डेटा किसी भी तीसरे पक्ष के साथ साझा नहीं किया जाता है।',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(
                      AppTexts.tr('terms_of_service'),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textHint),
                    onTap: () {
                      _showInfoDialog(
                        AppTexts.tr('terms_of_service'),
                        'यह ऐप किसानों की सुविधा के लिए मंडी भाव, मौसम और दैनिक हिसाब रखने हेतु बनाया गया है। भाव विभिन्न सरकारी व स्थानीय मंडियों से एकत्रित किए जाते हैं।',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTexts.tr('app_name'),
                          style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppTexts.tr('app_version'),
                          style: TextStyle(fontSize: 12.sp, color: AppTheme.textHint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ─────────────────────────────────────────────────────────────
            // 6. Logout Button
            // ─────────────────────────────────────────────────────────────
            InkWell(
              onTap: _showLogoutDialog,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppTheme.error, size: 18),
                    SizedBox(width: 8.w),
                    Text(
                      AppTexts.tr('logout_btn'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),
            Center(
              child: Text(
                AppTexts.tr('made_for_farmers'),
                style: TextStyle(fontSize: 11.sp, color: AppTheme.textHint),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppTheme.primaryColor),
        SizedBox(width: 8.w),
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

  Widget _buildLanguageCard({
    required String title,
    required String subtitle,
    required String flagEmoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(flagEmoji, style: TextStyle(fontSize: 20.sp)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
