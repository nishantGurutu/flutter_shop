import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/services/farmer_profile_service.dart';

/// Service responsible for managing app language dynamically across the entire app.
/// Persists user selection in SharedPreferences and notifies listeners for live UI updates.
class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  static LanguageService get instance => _instance;

  factory LanguageService() => _instance;

  LanguageService._internal();

  static const String _prefLanguageKey = 'selected_app_language';

  // Default language is Hindi ('hi')
  String _currentLanguage = 'hi';

  String get currentLanguage => _currentLanguage;
  bool get isHindi => _currentLanguage == 'hi';
  bool get isEnglish => _currentLanguage == 'en';

  Locale get currentLocale => Locale(_currentLanguage);

  /// Load persisted language choice on app startup
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(_prefLanguageKey);
      if (savedLang != null && (savedLang == 'hi' || savedLang == 'en')) {
        _currentLanguage = savedLang;
      } else {
        _currentLanguage = 'hi';
      }
    } catch (_) {
      _currentLanguage = 'hi';
    }
    _syncWithProfileService();
  }

  /// Change language dynamically ('hi' for Hindi, 'en' for English)
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != 'hi' && languageCode != 'en') return;
    if (_currentLanguage == languageCode) return;

    _currentLanguage = languageCode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLanguageKey, languageCode);
    } catch (_) {}

    _syncWithProfileService();
    notifyListeners();
  }

  void _syncWithProfileService() {
    try {
      final profileLangText = _currentLanguage == 'hi' ? 'हिंदी (Hindi)' : 'English';
      FarmerProfileService().updateProfile(language: profileLangText);
    } catch (_) {}
  }
}
