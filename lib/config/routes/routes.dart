import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/view/authorised/cart/cart_screen.dart';
import 'package:shop/view/authorised/home/home_screen.dart';
import 'package:shop/view/authorised/professional/professional_list_screen.dart';
import 'package:shop/bloc/professional_list_bloc/professional_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shop/view/unauthorised/login_screen.dart';
import 'package:shop/view/unauthorised/splash_screen.dart';
import 'package:shop/view/unauthorised/onbording_screen.dart';
import 'package:shop/bloc/onbording_bloc/onbording_bloc.dart';
import 'package:shop/view/authorised/professional/professional_profile_screen.dart';
import 'package:shop/bloc/professional_profile_bloc/professional_profile_bloc.dart';
import 'package:shop/view/authorised/booking/booking_appointment_screen.dart';
import 'package:shop/bloc/booking_bloc/booking_bloc.dart';
import 'package:shop/model/professional/professional_model.dart';
import 'package:shop/view/product_details/product_details.dart';
import 'package:shop/view/desktop/layout/responsive_wrapper.dart';
import 'package:shop/view/authorised/store/store.dart';
import 'package:shop/view/authorised/notification/notification_screen.dart';
import 'package:shop/view/authorised/profile_screen/profile_screen.dart';
import 'package:shop/view/authorised/order/order_screen.dart';
import 'package:shop/view/authorised/advise/advice_screen.dart';
import 'package:shop/view/authorised/weather/weather_advisory_screen.dart';
import 'package:shop/view/authorised/mandi/mandi_screen.dart';
import 'package:shop/view/authorised/khata/khata_screen.dart';
import 'package:shop/view/unauthorised/profile_setup_screen.dart';
import 'package:shop/view/authorised/settings/settings_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );

      case RoutesName.onboarding:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => OnbordingBloc(),
            child: const OnbordingScreen(),
          ),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        );

      case RoutesName.bottom_bar:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ResponsiveWrapper(),
        );

      case RoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesName.professionalList:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => ProfessionalListBloc(),
            child: ProfessionalListScreen(category: args ?? 'Professionals'),
          ),
        );

      case RoutesName.professionalProfile:
        final prof = settings.arguments as ProfessionalModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => ProfessionalProfileBloc(),
            child: ProfessionalProfileScreen(professional: prof),
          ),
        );

      case RoutesName.bookAppointment:
        final prof2 = settings.arguments as ProfessionalModel?;
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => BookingBloc(),
            child: BookingAppointmentScreen(professional: prof2),
          ),
        );

      case RoutesName.productDetails:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ProductDetailScreen(),
        );

      case RoutesName.cart:
        return MaterialPageRoute(
          builder: (BuildContext context) => const CartScreen(),
        );

      case RoutesName.store:
        return MaterialPageRoute(
          builder: (BuildContext context) => const StoreScreen(),
        );

      case RoutesName.notification:
        return MaterialPageRoute(
          builder: (BuildContext context) => const NotificationScreen(),
        );

      case RoutesName.profile:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ProfileScreen(),
        );

      case RoutesName.order:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OrderScreen(),
        );

      case RoutesName.advice:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AdviceScreen(),
        );

      case RoutesName.weatherAdvisory:
        return MaterialPageRoute(
          builder: (BuildContext context) => const WeatherAdvisoryScreen(),
        );

      case RoutesName.mandi:
        return MaterialPageRoute(
          builder: (BuildContext context) => const MandiScreen(),
        );

      case RoutesName.khata:
        return MaterialPageRoute(
          builder: (BuildContext context) => const KhataScreen(),
        );

      case RoutesName.profileSetup:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ProfileSetupScreen(),
        );

      case RoutesName.settings:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No route defined')),
            );
          },
        );
    }
  }
}
