import 'package:flutter/material.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/features/auth/auth_service.dart';
import 'package:shop/features/auth/auth_flow.dart';
import 'package:shop/services/onboarding_storage_service.dart';

class SplashService {
  Future<void> isLogin(BuildContext context) async {
    final onboarded = await OnboardingStorageService.isOnboardingCompleted();
    final auth = AuthService.instance;
    final signedIn = await auth.restore();
    if (!context.mounted) return;
    if (signedIn) await prepareSignedInAccount(auth.user!);
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      signedIn
          ? RoutesName.bottom_bar
          : (onboarded ? RoutesName.login : RoutesName.onboarding),
      (_) => false,
    );
  }
}
