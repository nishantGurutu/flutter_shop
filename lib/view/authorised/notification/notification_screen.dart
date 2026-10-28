import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedCategory = 'सभी';

  final List<String> _categories = [
    'सभी',
    'दैनिक बुलेटिन (Morning)',
    'भाव अलर्ट (Rates)',
    'मौसम चेतावनी (Weather)',
    'दुकान व खाद (Store)',
  ];

  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': 'notif_morning',
      'type': 'दैनिक बुलेटिन (Morning)',
      'title': '🌅 आज का दैनिक किसान बुलेटिन (7:00 AM)',
      'body':
          'मौसम: आज धूप खिली रहेगी (27°C)। सुबह 8:00 से 11:00 AM के बीच स्प्रे का सबसे उत्तम समय है।\nमंडी: नीमच मंडी में गेहूं ₹2,650 (+₹45) मजबूत खुला। चना ₹5,850 पर।\nआज का काम: सरसों में माहू (Aphids) का निरीक्षण करें।',
      'time': 'आज सुबह 7:00 AM',
      'icon': Icons.wb_twilight,
      'color': '#2E7D32',
      'gradient': ['#2E7D32', '#388E3C'],
      'isRead': false,
      'isMorningBulletin': true,
      'actionRoute': RoutesName.weatherAdvisory,
    },
    {
      'id': 'notif_rate_1',
      'type': 'भाव अलर्ट (Rates)',
      'title': '🔔 गेहूं भाव अलर्ट: ₹2,650 पहुंचा!',
      'body':
          'नीमच मंडी में गेहूं लोकवन ग्रेड A का भाव आज ₹2,650/क्विंटल पहुंचा, जो आपके लक्ष्य भाव के करीब है।',
      'time': '10 मिनट पहले',
      'icon': Icons.notifications_active,
      'color': '#FF9800',
      'gradient': ['#FF9800', '#F57C00'],
      'isRead': false,
      'actionRoute': RoutesName.mandi,
    },
    {
      'id': 'notif_weather_1',
      'type': 'मौसम चेतावनी (Weather)',
      'title': '🌿 स्प्रे सलाह: आज छिड़काव के लिए उत्तम दिन',
      'body':
          'हवा की गति 9 km/h अनुकूल है और बारिश की केवल 10% संभावना है। सुबह 7:30 से 10:30 AM के बीच स्प्रे करें।',
      'time': 'आज सुबह 6:30 AM',
      'icon': Icons.sanitizer,
      'color': '#0288D1',
      'gradient': ['#0288D1', '#0277BD'],
      'isRead': true,
      'actionRoute': RoutesName.weatherAdvisory,
    },
    {
      'id': 'notif_khata_1',
      'type': 'दैनिक बुलेटिन (Morning)',
      'title': '📝 किसान खाता: कल का हिसाब दर्ज करें',
      'body':
          'क्या आपने कल खाद या डीजल का कोई खर्च किया? माइक बटन दबाकर बोलें और खाते में सहेजें।',
      'time': 'कल रात 8:00 PM',
      'icon': Icons.mic,
      'color': '#7B1FA2',
      'gradient': ['#7B1FA2', '#6A1B9A'],
      'isRead': true,
      'actionRoute': RoutesName.khata,
    },
    {
      'id': 'notif_store_1',
      'type': 'दुकान व खाद (Store)',
      'title': '📦 खाद स्टॉक: IFFCO DAP व यूरिया उपलब्ध',
      'body':
          'आपके नजदीकी केंद्र पर प्रमाणित डीएपी खाद का नया स्टॉक पहुंच गया है। घर बैठे आर्डर करें।',
      'time': 'कल दोपहर 2:00 PM',
      'icon': Icons.local_shipping,
      'color': '#00796B',
      'gradient': ['#00796B', '#004D40'],
      'isRead': true,
      'actionRoute': RoutesName.store,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedCategory == 'सभी'
        ? _allNotifications
        : _allNotifications
              .where((n) => n['type'] == _selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('सूचनाएं व दैनिक बुलेटिन'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _allNotifications) {
                  n['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('सभी सूचनाएं पढ़ी हुई चिह्नित की गईं'),
                ),
              );
            },
            child: Text(
              'सब पढ़ा हुआ',
              style: TextStyle(color: AppTheme.primaryColor, fontSize: 13.sp),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter Pills
            SizedBox(
              height: 38.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSel,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSel
                            ? AppTheme.primaryColor
                            : const Color(0xFFE0E0E0),
                      ),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppTheme.textPrimary,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Notifications List
            ...filteredList.map((notif) => _buildNotificationCard(notif)),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final isMorning = notif['isMorningBulletin'] == true;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isMorning
              ? AppTheme.primaryColor.withValues(alpha: 0.6)
              : const Color(0xFFEAEAEA),
          width: isMorning ? 1.5 : 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Gradient Banner for Morning Bulletin
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(
                    int.parse(notif['gradient'][0].replaceAll('#', '0xFF')),
                  ),
                  Color(
                    int.parse(notif['gradient'][1].replaceAll('#', '0xFF')),
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(notif['icon'], color: Colors.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      notif['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                if (!notif['isRead'])
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD54F),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),

          // Body Content
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['body'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.textPrimary,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notif['time'],
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.textHint,
                      ),
                    ),
                    if (notif['actionRoute'] != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, notif['actionRoute']);
                        },
                        child: Row(
                          children: [
                            Text(
                              'विस्तार से देखें',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward,
                              size: 14.sp,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
