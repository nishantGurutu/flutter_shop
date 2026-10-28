import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'package:shop/view/widgets/common/custom_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = FarmerProfileService();

  @override
  void initState() {
    super.initState();
    _profileService.addListener(_onProfileUpdate);
  }

  @override
  void dispose() {
    _profileService.removeListener(_onProfileUpdate);
    super.dispose();
  }

  void _onProfileUpdate() {
    if (mounted) setState(() {});
  }

  void _showBusinessPlanModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kisan Daily: Business Plan',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Phase 1 se 3',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Farmer ke liye free daily app. Farmer roz mausam, mandi bhaav aur khata ke liye kholega, aur kamai un companies se hogi jinhe farmer tak pahunchna hai.',
                    style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary, height: 1.4),
                  ),
                  SizedBox(height: 16.h),

                  // Phase 1 Card (Current Phase)
                  _buildPhaseCard(
                    phase: 'Phase 1: MVP (0-3 mahine)',
                    status: 'वर्तमान चरण (Active)',
                    statusColor: AppTheme.success,
                    goal: '1,000 active farmers jodna. Roz app kholne ki aadat daalna.',
                    features: [
                      'Mobile OTP login aur profile (gaon, fasal, bhasha) ✅',
                      'Mausam aur spray/sinchai ki seedhi salah ✅',
                      'Mandi bhaav aur rate alert ✅',
                      'Khata (kharcha/kamai), voice input ke saath ✅',
                      'Subah ka daily notification (7:00 AM) ✅',
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Phase 2 Card
                  _buildPhaseCard(
                    phase: 'Phase 2: Growth (3-6 mahine)',
                    status: 'आगामी (Next)',
                    statusColor: AppTheme.secondaryColor,
                    goal: '5,000 farmers, pehli kamai (dukaandar, beej/khaad companies).',
                    features: [
                      'Fasal calendar aur aaj ke kaam ki reminder',
                      'Fasal doctor: patte ki photo se bimari/keede ki pehchaan (AI)',
                      'Sarkari yojana aur last date reminder (PM-KISAN, bima)',
                      'Inputs listing: beej, khaad, dawai, local dukaandaron ke saath',
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Phase 3 Card
                  _buildPhaseCard(
                    phase: 'Phase 3: Marketplace & Scale (6-12 mahine)',
                    status: 'योजनाबद्ध (Planned)',
                    statusColor: Colors.purple,
                    goal: '20,000+ farmers, marketplace commission, bank/bima leads.',
                    features: [
                      'Marketplace: beej/khaad kharidna, fasal bechna, machine kiraya',
                      'Bank, bima aur loan apply (farmer ki sahmati ke saath)',
                      'Meri Zameen: farmer ka verified record',
                      'Naye districts ke liye local bhasha aur fasal',
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Sabhi Phases Ke Zaroori Niyam (from page 4)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: const Color(0xFFFFE082)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📌 सभी फेज़ के लिए ज़रूरी नियम (DPDP Act & Rules)',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF57F17),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildRuleBullet('Farmer ka data bina uski sahmati ke kisi company ko mat becho'),
                        _buildRuleBullet('Pehle ek district aur 1-2 fasal par focus karo'),
                        _buildRuleBullet('Users jud jaane ke baad hi companies se paisa maango'),
                        _buildRuleBullet('Ek saath bahut saare features mat banao'),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhaseCard({
    required String phase,
    required String status,
    required Color statusColor,
    required String goal,
    required List<String> features,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phase,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'लक्ष्य: $goal',
            style: TextStyle(fontSize: 12.sp, color: AppTheme.primaryDark, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          ...features.map((f) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRuleBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFFF57F17)),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF5D4037)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('मेरी किसान प्रोफ़ाइल'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
            tooltip: 'बिज़नेस प्लान',
            onPressed: _showBusinessPlanModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12.h),

            // Profile Header Card (Gaon, Fasal, Bhasha)
            _buildFarmerProfileHeader(),

            SizedBox(height: 14.h),

            // Business Plan Highlight Card
            _buildBusinessPlanBanner(),

            SizedBox(height: 14.h),

            // Farmer App Menu Options
            _buildFarmerMenuItems(),

            SizedBox(height: 20.h),

            // Logout Button
            _buildLogoutButton(),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerProfileHeader() {
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 66.w,
                height: 66.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryLight, width: 2),
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Text('🌾', style: TextStyle(fontSize: 32.sp)),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profileService.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      _profileService.phone,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppTheme.primaryColor),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            '${_profileService.village}, ${_profileService.district} (${_profileService.landArea})',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.textHint,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
                onPressed: () => Navigator.pushNamed(context, RoutesName.profileSetup),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Primary Crops Tags
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6.w,
              children: _profileService.selectedCrops.map((c) {
                return Chip(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFFF1F8E9),
                  side: const BorderSide(color: Color(0xFFC8E6C9)),
                  label: Text(
                    c,
                    style: TextStyle(fontSize: 11.sp, color: AppTheme.primaryDark),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 14.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('रेट अलर्ट', '${_profileService.rateAlerts.length}'),
              _buildStatDivider(),
              _buildStatItem('खाता बचत', '₹${_profileService.netMunafa.toStringAsFixed(0)}'),
              _buildStatDivider(),
              _buildStatItem('फसलें', '${_profileService.selectedCrops.length}'),
              _buildStatDivider(),
              _buildStatItem('भाषा', _profileService.language.split(' ')[0]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 28.h,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildBusinessPlanBanner() {
    return GestureDetector(
      onTap: _showBusinessPlanModal,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'किसान ऐप बिज़नेस प्लान (Phase 1 से 3)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Phase 1 MVP • 1,000 किसान • मौसम, मंडी व खाता',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerMenuItems() {
    final items = [
      {
        'title': 'गाँव, फसल व भाषा सेटिंग्स (Profile Setup)',
        'icon': Icons.tune,
        'action': () => Navigator.pushNamed(context, RoutesName.profileSetup),
      },
      {
        'title': 'ताज़ा मंडी भाव व रेट अलर्ट (Mandi & Alerts)',
        'icon': Icons.storefront_outlined,
        'action': () => Navigator.pushNamed(context, RoutesName.mandi),
      },
      {
        'title': 'मौसम व स्प्रे/सिंचाई सलाह (Weather Advisory)',
        'icon': Icons.wb_sunny_outlined,
        'action': () => Navigator.pushNamed(context, RoutesName.weatherAdvisory),
      },
      {
        'title': 'किसान दैनिक खाता (Khata with Voice)',
        'icon': Icons.menu_book_outlined,
        'action': () => Navigator.pushNamed(context, RoutesName.khata),
      },
      {
        'title': 'खाद-बीज दुकान (Fertilizer Store)',
        'icon': Icons.shopping_bag_outlined,
        'action': () => Navigator.pushNamed(context, RoutesName.store),
      },
      {
        'title': 'मेरे आर्डर (My Orders)',
        'icon': Icons.receipt_long_outlined,
        'action': () => Navigator.pushNamed(context, RoutesName.order),
      },
      {
        'title': 'दैनिक बुलेटिन व सूचनाएं (Morning Bulletin)',
        'icon': Icons.notifications_none_rounded,
        'action': () => Navigator.pushNamed(context, RoutesName.notification),
      },
    ];

    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: AppTheme.primaryColor,
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: AppTheme.textHint,
                ),
                onTap: item['action'] as VoidCallback,
              ),
              if (!isLast) Divider(height: 1, indent: 64.w, endIndent: 16.w),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, RoutesName.login);
        },
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: AppTheme.error, size: 18),
              SizedBox(width: 8.w),
              Text(
                'लॉग आउट (Logout)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
