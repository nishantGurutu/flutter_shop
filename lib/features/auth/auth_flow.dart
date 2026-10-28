import 'package:shop/services/language_service.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'package:shop/features/daily/daily_store.dart';
import 'auth_service.dart';

Future<void> prepareSignedInAccount(AuthUser user) async {
  await FarmerProfileService().useAccount(user.id);
  await DailyStore.instance.useAccount(user.id);
  FarmerProfileService().applyServerProfile(user.profile);
  await FarmerProfileService().flush();
  await LanguageService.instance.changeLanguage(
    user.profile['language'] == 'English' ? 'en' : 'hi',
  );
}

Future<void> clearSignedInAccount() async {
  await FarmerProfileService().useAccount(null);
  await DailyStore.instance.useAccount(null);
}
