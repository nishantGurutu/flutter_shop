import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/cart_bloc/cart_bloc.dart';
import 'package:shop/bloc/home_bloc/home_bloc.dart';
import 'package:shop/bloc/navigation/navigation_bloc.dart';
import 'package:shop/bloc/order_bloc/order_bloc.dart';
import 'package:shop/dependency_injection/locator.dart';
import 'package:shop/view/authorised/bottom_bar/bottom_bar.dart';
import 'package:shop/view/desktop/layout/main_layout.dart';

/// Decides which layout to render based on the current platform.
///
/// - Windows / macOS / Linux / Web → Desktop dashboard (MainLayout)
/// - Android / iOS                 → Mobile bottom-nav (BottomBarScreen)
class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({super.key});

  /// Returns true when running on a desktop-class platform.
  static bool get _isDesktop {
    if (kIsWeb) return true;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDesktop) {
      // Desktop: provide NavigationBloc + shared BLoCs, then show MainLayout
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(
              create: (_) => HomeBloc(homeRepository: getIt<HomeRepository>())),
          BlocProvider(create: (_) => OrderBloc()),
        ],
        child: const MainLayout(),
      );
    }

    // Mobile: existing bottom-nav layout (already has its own BlocProviders)
    return BottomBarScreen();
  }
}
