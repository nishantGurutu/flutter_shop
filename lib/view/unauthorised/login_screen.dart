import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/utils/const_image.dart';
import 'package:shop/view/unauthorised/profile_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController(text: '9876543210');
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isOtpSent = false;
  bool _isLoading = false;
  int _resendCountdown = 30;
  Timer? _timer;

  @override
  void dispose() {
    _mobileController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendCountdown = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _sendOtp() {
    final mobile = _mobileController.text.trim();
    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सही 10 अंकों का मोबाइल नंबर दर्ज करें')),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
      _startTimer();

      // Pre-fill demo OTP 123456 for convenience
      const demoOtp = '123456';
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = demoOtp[i];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP भेजा गया: +91 $mobile (डेमो OTP: 123456)'),
          backgroundColor: AppTheme.success,
        ),
      );
    });
  }

  void _verifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया 6 अंकों का OTP दर्ज करें')),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Navigate to Profile Setup Screen (Phase 1 flow)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(
            mobileNumber: '+91 ${_mobileController.text.trim()}',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            height: size.height * 0.55,
            width: double.infinity,
            child: Image.asset(
              loginBackgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ),
          ),

          // Header Overlay with Logo
          Positioned(
            top: 50.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: Image.asset(
                    splashImage,
                    height: 50.h,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.agriculture,
                      size: 40.sp,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "किसान साथी • Kisan Daily",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "रोज़ का मौसम • मंडी भाव • किसान खाता",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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

                    // Title
                    Text(
                      _isOtpSent ? "OTP सत्यापन (Verify OTP)" : "लॉगिन करें (Mobile Login)",
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _isOtpSent
                          ? "+91 ${_mobileController.text} पर 6 अंकों का कोड भेजा गया है"
                          : "अपने मोबाइल नंबर से 1-क्लिक OTP द्वारा जुड़े",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 18.h),

                    if (!_isOtpSent) ...[
                      // Mobile Input
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Row(
                          children: [
                            Text(
                              "🇮🇳 +91",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(width: 1, height: 26.h, color: Colors.grey[300]),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TextField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "98765 43210",
                                  counterText: "",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Send OTP Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _isLoading ? null : _sendOtp,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "OTP प्राप्त करें (Send OTP)",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 12.h),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, RoutesName.bottom_bar);
                          },
                          child: Text(
                            "अतिथि के रूप में देखें (Skip as Guest)",
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // 6 Digits OTP Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 44.w,
                            height: 50.h,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDark,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                if (val.isNotEmpty && index < 5) {
                                  _otpFocusNodes[index + 1].requestFocus();
                                } else if (val.isEmpty && index > 0) {
                                  _otpFocusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 12.h),

                      // Resend & Change Number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => _isOtpSent = false);
                            },
                            child: Text(
                              "नंबर बदलें (Edit)",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _resendCountdown > 0
                              ? Text(
                                  "दोबारा भेजें ($_resendCountdown s)",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppTheme.textHint,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _sendOtp,
                                  child: Text(
                                    "OTP दोबारा भेजें (Resend)",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Verify OTP Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _isLoading ? null : _verifyOtp,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "सत्यापित करें व आगे बढ़ें (Verify OTP)",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
