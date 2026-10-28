import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/config/routes/routes.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/dependency_injection/locator.dart';

void main() {
  ServiceLocator().servicesLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider<CartBloc>.value(
          value: getIt<CartBloc>(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kisan Sathi',
            theme: AppTheme.lightTheme,
            initialRoute: RoutesName.splash,
            onGenerateRoute: Routes.generateRoute,
          ),
        );
      },
    );
  }
}
