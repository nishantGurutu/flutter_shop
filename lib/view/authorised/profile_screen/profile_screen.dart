import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/json_models/profile_model.dart';
import 'package:shop/services/json_data_service.dart';
import 'package:shop/view/widgets/common/custom_card.dart';
import 'package:shop/view/widgets/common/loading_widget.dart' as common;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = JsonDataService.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Account'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<ProfileModel>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const common.LoadingWidget();
          }

          if (snapshot.hasError) {
            return common.ErrorDisplayWidget(
              message: 'Failed to load profile',
              onRetry: () {
                setState(() {
                  _profileFuture = JsonDataService.loadProfile();
                });
              },
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                // Profile Header
                _buildProfileHeader(profile.user, profile.stats),
                SizedBox(height: 16.h),
                // Menu Items
                _buildMenuItems(profile.menuItems),
                SizedBox(height: 16.h),
                // Logout Button
                _buildLogoutButton(),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserProfileModel user, UserStatsModel stats) {
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryLight, width: 2),
                  image: DecorationImage(
                    image: AssetImage(user.avatar),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    user.avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[400], size: 36.sp),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      user.phone,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      user.location.fullAddress,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textHint,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Orders', stats.totalOrders.toString()),
              _buildStatDivider(),
              _buildStatItem('Spent', '₹${stats.totalSpent.toStringAsFixed(0)}'),
              _buildStatDivider(),
              _buildStatItem('Crops', stats.cropsManaged.toString()),
              _buildStatDivider(),
              _buildStatItem('Advisory', stats.advisorySessions.toString()),
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
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildMenuItems(List<MenuItemModel> menuItems) {
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'receipt_long':
          return Icons.receipt_long_outlined;
        case 'person_outline':
          return Icons.person_outline;
        case 'location_on_outlined':
          return Icons.location_on_outlined;
        case 'credit_card':
          return Icons.credit_card_outlined;
        case 'help_outline':
          return Icons.help_outline;
        case 'info_outline':
          return Icons.info_outline;
        default:
          return Icons.circle_outlined;
      }
    }

    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.zero,
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    getIcon(item.icon),
                    color: AppTheme.primaryColor,
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: AppTheme.textHint,
                ),
                onTap: () {
                  switch (item.id) {
                    case 'orders':
                      Navigator.pushNamed(context, RoutesName.order);
                      break;
                  }
                },
              ),
              if (!isLast)
                Divider(height: 1, indent: 70.w, endIndent: 16.w),
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
          // Handle logout
        },
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppTheme.error, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
