import 'package:flutter/material.dart';
import 'package:shop/services/language_service.dart';

/// Centralized localization file containing all texts for the entire Kisan Saathi app.
/// Supports multiple languages (Hindi & English).
class AppTexts {
  AppTexts._();

  // ─────────────────────────────────────────────────────────────────────────
  // ALL APP TEXTS DICTIONARY (Single Centralized File)
  // ─────────────────────────────────────────────────────────────────────────
  static const Map<String, Map<String, String>> _values = {
    'hi': {
      // App General
      'app_name': 'किसान साथी',
      'app_tagline': 'किसानों का डिजिटल सच्चा साथी',
      'app_version': 'वर्शन 1.0.0+1',
      'made_for_farmers': 'भारतीय किसानों के लिए समर्पित 🌾',

      // Navigation Bottom Bar
      'nav_home': 'होम',
      'nav_store': 'दुकान',
      'nav_profile': 'प्रोफ़ाइल',
      'nav_settings': 'सेटिंग्स',
      'nav_mandi': 'मंडी भाव',
      'nav_khata': 'खाता 🎙️',
      'nav_weather': 'मौसम',

      // Common Buttons & Actions
      'ok': 'ठीक है',
      'cancel': 'रद्द करें',
      'save': 'सुरक्षित करें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      'search': 'खोजें...',
      'view_all': 'सभी देखें',
      'add': 'जोड़ें',
      'back': 'वापस',
      'retry': 'पुनः प्रयास करें',
      'close': 'बंद करें',
      'continue_text': 'आगे बढ़ें',
      'submit': 'जमा करें',
      'confirm': 'पुष्टि करें',
      'yes': 'हाँ',
      'no': 'नहीं',
      'call': 'कॉल करें',
      'chat': 'चैट करें',

      // Home Screen
      'greeting_morning': 'सुप्रभात',
      'greeting_namaste': 'नमस्ते',
      'farmer_greeting': 'नमस्ते, {name} जी! 🙏',
      'weather_safe_tag': 'आज स्प्रे के लिए उत्तम दिन है',
      'weather_temp': '27°C • नीमच',
      'weather_advisory_card_title': 'आज की मौसम व कृषि सलाह',
      'weather_spray_safe': 'हवा 9 km/h शांत है, स्प्रे के लिए सुरक्षित',
      'view_weather_details': 'मौसम सलाह देखें →',
      'quick_actions': 'त्वरित सेवाएं',
      'action_mandi': 'मंडी भाव',
      'action_mandi_sub': 'ताज़ा रेट व आवक',
      'action_weather': 'मौसम सलाह',
      'action_weather_sub': 'स्प्रे व सिंचाई',
      'action_khata': 'किसान खाता',
      'action_khata_sub': 'बोलकर हिसाब',
      'action_store': 'खाद-बीज दुकान',
      'action_store_sub': 'उत्पाद व खाद',
      'action_doctor': 'डॉक्टर सलाह',
      'action_doctor_sub': 'फसल विशेषज्ञ',
      'action_diagnosis': 'कीट पहचान',
      'action_diagnosis_sub': 'फोटो से जांच',
      'latest_mandi_rates': 'ताज़ा मंडी भाव',
      'mandi_arrival_today': 'नीमच मंडी • आज की आवक',
      'crop_wheat': 'गेहूं (Wheat)',
      'crop_chana': 'चना (Chana)',
      'crop_mustard': 'सरसों (Mustard)',
      'crop_soyabean': 'सोयाबीन (Soyabean)',
      'crop_garlic': 'लहसुन (Garlic)',
      'voice_khata_banner_title': '🎙️ बोलकर खर्च या कमाई जोड़ें',
      'voice_khata_banner_desc': 'जैसे: "2 बोरी डीएपी 2700 रुपये" या "10 क्विंटल गेहूं बेचा 26000 रुपये"',
      'voice_khata_btn': 'बोलकर दर्ज करें',
      'rate_alerts_banner': '🔔 रेट अलर्ट सक्रिय है',

      // Settings Screen
      'settings_title': 'सेटिंग्स (Settings)',
      'settings_language_section': 'भाषा का चयन (Choose Language)',
      'settings_language_desc': 'ऐप की भाषा तुरंत बदलने के लिए टैप करें',
      'lang_hindi': 'हिंदी (Hindi)',
      'lang_hindi_sub': 'ऐप पूर्णतः हिंदी में उपयोग करें',
      'lang_english': 'English',
      'lang_english_sub': 'Use application in English',
      'settings_profile_section': 'किसान प्रोफ़ाइल विवरण',
      'farmer_name': 'किसान का नाम',
      'farmer_phone': 'मोबाइल नंबर',
      'farmer_location': 'गाँव व ज़िला',
      'farmer_land': 'ज़मीन (Land)',
      'edit_profile_btn': 'प्रोफ़ाइल बदलें (Edit Profile)',
      'settings_pref_section': 'ऐप प्राथमिकताएं व अलर्ट',
      'pref_notifications': 'पुश सूचनाएं (Push Notifications)',
      'pref_notifications_sub': 'मंडी भाव में उतार-चढ़ाव की सूचना',
      'pref_weather_alerts': 'दैनिक मौसम अलर्ट (Daily Weather Bulletin)',
      'pref_weather_alerts_sub': 'सुबह 7:00 बजे आज के स्प्रे व सिंचाई की सलाह',
      'pref_voice_assistant': 'स्मार्ट वॉयस सहायता (Voice Prompts)',
      'pref_voice_assistant_sub': 'खाते में बोलकर एंट्री करते समय सुझाव',
      'settings_help_section': 'किसान सहायता केंद्र (Support)',
      'kisan_helpline': 'किसान कॉल सेंटर (टोल-फ्री)',
      'kisan_helpline_num': '1800-180-1551',
      'whatsapp_help': 'व्हाट्सएप कृषि मित्र सपोर्ट',
      'whatsapp_help_desc': 'फसल की बीमारी का फोटो भेजें',
      'faq_title': 'अक्सर पूछे जाने वाले सवाल (FAQs)',
      'faq_desc': 'मंडी भाव, खाता व स्प्रे से जुड़े सवाल',
      'settings_about_section': 'ऐप की जानकारी (About)',
      'privacy_policy': 'गोपनीयता नीति (Privacy Policy)',
      'terms_of_service': 'नियम व शर्तें (Terms of Service)',
      'logout_btn': 'लॉग आउट (Logout)',
      'logout_dialog_title': 'लॉग आउट करें?',
      'logout_dialog_msg': 'क्या आप वास्तव में अपने खाते से लॉग आउट करना चाहते हैं?',
      'language_updated_toast': 'भाषा बदलकर हिंदी कर दी गई है!',

      // Mandi Screen
      'mandi_title': 'मंडी भाव व रेट अलर्ट',
      'search_crop_mandi': 'फसल या मंडी खोजें...',
      'filter_all_crops': 'सभी फसलें',
      'modal_price': 'मॉडल भाव',
      'min_price': 'न्यूनतम',
      'max_price': 'अधिकतम',
      'arrival': 'कुल आवक',
      'set_alert': 'अलर्ट लगाएं',
      'alert_active': 'अलर्ट चालू है',
      'rate_trend': 'भाव रुझान',

      // Khata Screen
      'khata_title': 'किसान दैनिक खाता 🎙️',
      'total_kharcha': 'कुल खर्च',
      'total_kamai': 'कुल कमाई',
      'net_munafa': 'शुद्ध बचत/मुनाफा',
      'add_kharcha': 'खर्च जोड़ें (-)',
      'add_kamai': 'कमाई जोड़ें (+)',
      'recent_entries': 'हालिया लेन-देन',
      'no_entries': 'अभी कोई लेन-देन नहीं जुड़ा है',
      'tap_to_speak': 'माइक दबाकर बोलें',
      'voice_hint': 'उदाहरण: "ट्रैक्टर जुताई 1500 रुपये"',

      // Weather Screen
      'weather_title': 'मौसम व कृषि सलाह',
      'hourly_forecast': 'घंटेवार मौसम पूर्वानुमान',
      'daily_forecast': 'अगले 5 दिनों का पूर्वानुमान',
      'spray_recommendation': 'स्प्रे सलाह व दवा मात्रा',
      'irrigation_status': 'सिंचाई स्थिति',
      'humidity': 'नमी',
      'wind_speed': 'हवा की गति',
      'rain_probability': 'बारिश की संभावना',

      // Store Screen
      'store_title': 'कृषि स्टोर (दुकान)',
      'search_products': 'खाद, बीज, कीटनाशक खोजें...',
      'all_categories': 'सभी श्रेणियां',
      'add_to_cart': 'कार्ट में डालें',
      'buy_now': 'अभी खरीदें',
      'in_stock': 'उपलब्ध है',
      'out_of_stock': 'उपलब्ध नहीं',
      'cart': 'कार्ट',
      'checkout': 'ऑर्डर पूरा करें',

      // Profile Screen
      'profile_title': 'किसान प्रोफ़ाइल',
      'crops_selected': 'चुनी गई मुख्य फसलें',
      'my_orders': 'मेरे ऑर्डर',
      'morning_bulletin': 'दैनिक बुलेटिन',
      'business_plan_banner': 'किसान ऐप बिज़नेस प्लान (Phase 1 से 3)',
      'stat_alerts': 'रेट अलर्ट',
      'stat_savings': 'खाता बचत',
      'stat_crops': 'फसलें',
      'stat_language': 'भाषा',
    },

    'en': {
      // App General
      'app_name': 'Kisan Saathi',
      'app_tagline': 'Digital Trusted Companion for Farmers',
      'app_version': 'Version 1.0.0+1',
      'made_for_farmers': 'Dedicated to Indian Farmers 🌾',

      // Navigation Bottom Bar
      'nav_home': 'Home',
      'nav_store': 'Store',
      'nav_profile': 'Profile',
      'nav_settings': 'Settings',
      'nav_mandi': 'Mandi Rates',
      'nav_khata': 'Khata 🎙️',
      'nav_weather': 'Weather',

      // Common Buttons & Actions
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'search': 'Search...',
      'view_all': 'View All',
      'add': 'Add',
      'back': 'Back',
      'retry': 'Retry',
      'close': 'Close',
      'continue_text': 'Continue',
      'submit': 'Submit',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'call': 'Call',
      'chat': 'Chat',

      // Home Screen
      'greeting_morning': 'Good Morning',
      'greeting_namaste': 'Welcome',
      'farmer_greeting': 'Hello, {name}! 🙏',
      'weather_safe_tag': 'Great day for spraying today',
      'weather_temp': '27°C • Neemuch',
      'weather_advisory_card_title': "Today's Weather & Agri Advisory",
      'weather_spray_safe': 'Wind 9 km/h is calm, safe for spraying',
      'view_weather_details': 'View Weather Advisory →',
      'quick_actions': 'Quick Services',
      'action_mandi': 'Mandi Rates',
      'action_mandi_sub': 'Daily rates & arrivals',
      'action_weather': 'Weather Advisory',
      'action_weather_sub': 'Spray & Irrigation',
      'action_khata': 'Kisan Khata',
      'action_khata_sub': 'Voice bookkeeping',
      'action_store': 'Agri Store',
      'action_store_sub': 'Fertilizers & seeds',
      'action_doctor': 'Doctor Advice',
      'action_doctor_sub': 'Crop specialists',
      'action_diagnosis': 'Pest Detection',
      'action_diagnosis_sub': 'Photo diagnosis',
      'latest_mandi_rates': 'Latest Mandi Rates',
      'mandi_arrival_today': 'Neemuch Mandi • Arrivals Today',
      'crop_wheat': 'Wheat (Gehun)',
      'crop_chana': 'Gram (Chana)',
      'crop_mustard': 'Mustard (Sarson)',
      'crop_soyabean': 'Soyabean',
      'crop_garlic': 'Garlic (Lahsun)',
      'voice_khata_banner_title': '🎙️ Add Expense or Income by Voice',
      'voice_khata_banner_desc': 'e.g. "2 bags DAP fertilizer 2700 rupees" or "Sold 10 quintal wheat 26000"',
      'voice_khata_btn': 'Record by Voice',
      'rate_alerts_banner': '🔔 Rate Alert Active',

      // Settings Screen
      'settings_title': 'Settings',
      'settings_language_section': 'Choose Language',
      'settings_language_desc': 'Tap to switch app language immediately',
      'lang_hindi': 'हिंदी (Hindi)',
      'lang_hindi_sub': 'Use app completely in Hindi',
      'lang_english': 'English',
      'lang_english_sub': 'Use app in English',
      'settings_profile_section': 'Farmer Profile Information',
      'farmer_name': 'Farmer Name',
      'farmer_phone': 'Mobile Number',
      'farmer_location': 'Village & District',
      'farmer_land': 'Land Area',
      'edit_profile_btn': 'Edit Profile',
      'settings_pref_section': 'App Preferences & Alerts',
      'pref_notifications': 'Push Notifications',
      'pref_notifications_sub': 'Mandi rate changes and market updates',
      'pref_weather_alerts': 'Daily Weather Bulletin',
      'pref_weather_alerts_sub': 'Morning 7:00 AM spray & irrigation advice',
      'pref_voice_assistant': 'Voice Assistant Guidance',
      'pref_voice_assistant_sub': 'Smart suggestions while adding voice entries',
      'settings_help_section': 'Kisan Support & Helpline',
      'kisan_helpline': 'Kisan Call Center (Toll-Free)',
      'kisan_helpline_num': '1800-180-1551',
      'whatsapp_help': 'WhatsApp Krishi Support',
      'whatsapp_help_desc': 'Send photo of affected crop / pest',
      'faq_title': 'Frequently Asked Questions (FAQs)',
      'faq_desc': 'Queries about Mandi rates, Khata & Spray tips',
      'settings_about_section': 'About Application',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'logout_btn': 'Logout',
      'logout_dialog_title': 'Logout?',
      'logout_dialog_msg': 'Are you sure you want to log out from your account?',
      'language_updated_toast': 'Language switched to English successfully!',

      // Mandi Screen
      'mandi_title': 'Mandi Rates & Alerts',
      'search_crop_mandi': 'Search crop or mandi...',
      'filter_all_crops': 'All Crops',
      'modal_price': 'Modal Price',
      'min_price': 'Min Price',
      'max_price': 'Max Price',
      'arrival': 'Total Arrival',
      'set_alert': 'Set Alert',
      'alert_active': 'Alert is Active',
      'rate_trend': 'Rate Trend',

      // Khata Screen
      'khata_title': 'Kisan Daily Khata 🎙️',
      'total_kharcha': 'Total Expense',
      'total_kamai': 'Total Income',
      'net_munafa': 'Net Savings/Profit',
      'add_kharcha': 'Add Expense (-)',
      'add_kamai': 'Add Income (+)',
      'recent_entries': 'Recent Transactions',
      'no_entries': 'No transactions added yet',
      'tap_to_speak': 'Tap mic to speak',
      'voice_hint': 'e.g. "Tractor plowing 1500 rupees"',

      // Weather Screen
      'weather_title': 'Weather & Crop Advisory',
      'hourly_forecast': 'Hourly Forecast',
      'daily_forecast': '5-Day Forecast',
      'spray_recommendation': 'Spray Recommendation & Dosage',
      'irrigation_status': 'Irrigation Advice',
      'humidity': 'Humidity',
      'wind_speed': 'Wind Speed',
      'rain_probability': 'Rain Chance',

      // Store Screen
      'store_title': 'Agri Store',
      'search_products': 'Search fertilizers, seeds, pesticides...',
      'all_categories': 'All Categories',
      'add_to_cart': 'Add to Cart',
      'buy_now': 'Buy Now',
      'in_stock': 'In Stock',
      'out_of_stock': 'Out of Stock',
      'cart': 'Cart',
      'checkout': 'Complete Order',

      // Profile Screen
      'profile_title': 'Farmer Profile',
      'crops_selected': 'Selected Main Crops',
      'my_orders': 'My Orders',
      'morning_bulletin': 'Daily Bulletin',
      'business_plan_banner': 'Kisan App Business Plan (Phase 1 to 3)',
      'stat_alerts': 'Rate Alerts',
      'stat_savings': 'Khata Savings',
      'stat_crops': 'Crops',
      'stat_language': 'Language',
    },
  };

  /// Translate a given key into current language or specified language code.
  static String tr(String key, {String? lang, Map<String, String>? params}) {
    final languageCode = lang ?? LanguageService.instance.currentLanguage;
    final dict = _values[languageCode] ?? _values['hi']!;
    var text = dict[key] ?? _values['en']?[key] ?? key;

    if (params != null && params.isNotEmpty) {
      params.forEach((paramKey, value) {
        text = text.replaceAll('{$paramKey}', value);
      });
    }

    return text;
  }

  // Convenience Typed Getters
  static String get appName => tr('app_name');
  static String get home => tr('nav_home');
  static String get store => tr('nav_store');
  static String get profile => tr('nav_profile');
  static String get settings => tr('nav_settings');
  static String get mandi => tr('nav_mandi');
  static String get khata => tr('nav_khata');
  static String get weather => tr('nav_weather');
  static String get settingsTitle => tr('settings_title');
  static String get editProfile => tr('edit_profile_btn');
  static String get logout => tr('logout_btn');
}
