import 'dart:async';
import 'package:shop/config/routes/routes_name.dart';
import 'package:flutter/material.dart';

class SplashService {
  Future<void> isLogin(BuildContext context) async {
    Timer(
      const Duration(seconds: 5),
      () async { 
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.onboarding, (route) => false);
      }
    );
  }
}
