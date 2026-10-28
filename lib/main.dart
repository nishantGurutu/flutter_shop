import 'package:shop/features/auth/auth_service.dart';
import 'package:shop/features/auth/auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'package:shop/features/daily/daily_store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/config/routes/routes.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/dependency_injection/locator.dart';
import 'package:shop/services/language_service.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().servicesLocator();
  await LanguageService.instance.init();
  await FarmerProfileService().useAccount(null);
  await DailyStore.instance.useAccount(null);
  AuthService.instance.onExpired = () async {
    await clearSignedInAccount();
    appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      RoutesName.login,
      (_) => false,
    );
  };
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
      builder: (screenContext, child) {
        final viewport = MediaQueryData.fromView(View.of(screenContext));
        final wideFarmerView =
            viewport.size.width > 600 &&
            !const bool.fromEnvironment('ADMIN_DASHBOARD');
        if (wideFarmerView) {
          ScreenUtil.configure(
            data: viewport.copyWith(size: Size(480, viewport.size.height)),
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
          );
        }
        return ListenableBuilder(
          listenable: LanguageService.instance,
          builder: (context, _) {
            return BlocProvider<CartBloc>.value(
              value: getIt<CartBloc>(),
              child: MaterialApp(
                navigatorKey: appNavigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Kisan Daily',
                builder: (context, page) {
                  if (!wideFarmerView) return page!;
                  return ColoredBox(
                    color: const Color(0xFFE8EEE4),
                    child: Center(
                      child: SizedBox(
                        width: 480,
                        child: MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(size: Size(480, viewport.size.height)),
                          child: page!,
                        ),
                      ),
                    ),
                  );
                },
                theme: AppTheme.lightTheme,
                locale: LanguageService.instance.currentLocale,
                initialRoute: RoutesName.splash,
                onGenerateRoute: Routes.generateRoute,
              ),
            );
          },
        );
      },
    );
  }
}
