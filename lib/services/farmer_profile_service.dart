import 'package:shop/features/daily/farmer_api.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/model/khata_model.dart';
import 'package:shop/model/mandi_model.dart';
import 'package:shop/model/weather_advisory_model.dart';

class FarmerProfileService extends ChangeNotifier {
  static final FarmerProfileService _instance =
      FarmerProfileService._internal();
  factory FarmerProfileService() => _instance;

  FarmerProfileService._internal();

  // --- Farmer Profile State ---
  String _name = 'किसान';
  String _phone = '';
  String _language = 'हिंदी (Hindi)';
  String _village = 'रामपुर कलां';
  String _district = 'नीमच';
  String _state = 'मध्य प्रदेश';
  String _landArea = '4.5 एकड़';
  List<String> _selectedCrops = [
    'गेहूं (Wheat)',
    'चना (Chana)',
    'सरसों (Mustard)',
  ];
  bool _isProfileCompleted = false;

  String get name => _name;
  String get phone => _phone;
  String get language => _language;
  String get village => _village;
  String get district => _district;
  String get state => _state;
  String get landArea => _landArea;
  List<String> get selectedCrops => List.unmodifiable(_selectedCrops);
  bool get isProfileCompleted => _isProfileCompleted;

  void updateLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? phone,
    String? language,
    String? village,
    String? district,
    String? state,
    String? landArea,
    List<String>? selectedCrops,
  }) {
    if (name != null) _name = name;
    if (phone != null) _phone = phone;
    if (language != null) _language = language;
    if (village != null) _village = village;
    if (district != null) _district = district;
    if (state != null) _state = state;
    if (landArea != null) _landArea = landArea;
    if (selectedCrops != null) _selectedCrops = selectedCrops;
    _isProfileCompleted = true;
    _liveWeather = null;
    _liveRates = null;
    notifyListeners();
    unawaited(refreshFeed());
  }

  // --- Mandi Rates & Rate Alerts ---
  String _selectedMandi = 'नीमच मंडी';
  final List<String> availableMandis = [
    'नीमच मंडी',
    'इंदौर मंडी',
    'मंदसौर मंडी',
    'कोटा मंडी',
  ];

  String get selectedMandi => _selectedMandi;

  void selectMandi(String mandi) {
    _selectedMandi = mandi;
    _liveRates = null;
    notifyListeners();
    unawaited(refreshFeed());
  }

  final List<MandiRateModel> _mandiRates = [
    const MandiRateModel(
      id: 'mr_1',
      mandiName: 'नीमच मंडी',
      district: 'नीमच',
      state: 'मध्य प्रदेश',
      cropName: 'Wheat',
      cropHindi: 'गेहूं (लोकवन/शरबती)',
      variety: 'लोकवन ग्रेड A',
      minPrice: 2420,
      modalPrice: 2650,
      maxPrice: 2840,
      priceChange: 45,
      arrival: '1,450 बोरी',
      date: 'आज, 26 अक्टूबर',
      icon: 'assets/json/crops.json',
    ),
    const MandiRateModel(
      id: 'mr_2',
      mandiName: 'नीमच मंडी',
      district: 'नीमच',
      state: 'मध्य प्रदेश',
      cropName: 'Gram',
      cropHindi: 'चना (देसी/कांटा)',
      variety: 'विशाल देसी',
      minPrice: 5450,
      modalPrice: 5850,
      maxPrice: 6200,
      priceChange: 80,
      arrival: '850 बोरी',
      date: 'आज, 26 अक्टूबर',
      icon: 'assets/json/crops.json',
    ),
    const MandiRateModel(
      id: 'mr_3',
      mandiName: 'नीमच मंडी',
      district: 'नीमच',
      state: 'मध्य प्रदेश',
      cropName: 'Mustard',
      cropHindi: 'सरसों (Mustard)',
      variety: 'काली सरसों 42% तेल',
      minPrice: 5180,
      modalPrice: 5540,
      maxPrice: 5860,
      priceChange: -25,
      arrival: '620 बोरी',
      date: 'आज, 26 अक्टूबर',
      icon: 'assets/json/crops.json',
    ),
    const MandiRateModel(
      id: 'mr_4',
      mandiName: 'नीमच मंडी',
      district: 'नीमच',
      state: 'मध्य प्रदेश',
      cropName: 'Soyabean',
      cropHindi: 'सोयाबीन (पीला)',
      variety: 'JS 9560',
      minPrice: 4250,
      modalPrice: 4620,
      maxPrice: 4850,
      priceChange: 30,
      arrival: '2,100 बोरी',
      date: 'आज, 26 अक्टूबर',
      icon: 'assets/json/crops.json',
    ),
    const MandiRateModel(
      id: 'mr_5',
      mandiName: 'नीमच मंडी',
      district: 'नीमच',
      state: 'मध्य प्रदेश',
      cropName: 'Garlic',
      cropHindi: 'लहसुन (ऊटी/देशी)',
      variety: 'रियावन सिल्वर',
      minPrice: 11500,
      modalPrice: 15400,
      maxPrice: 19200,
      priceChange: 350,
      arrival: '3,400 कट्टे',
      date: 'आज, 26 अक्टूबर',
      icon: 'assets/json/crops.json',
    ),
    const MandiRateModel(
      id: 'mr_6',
      mandiName: 'नीमच मंडी',
      district: 'नीमच',
      state: 'मध्य प्रदेश',
      cropName: 'Paddy',
      cropHindi: 'धान (बासमती 1509)',
      variety: 'सुगंधित बासमती',
      minPrice: 3200,
      modalPrice: 3580,
      maxPrice: 3950,
      priceChange: 0,
      arrival: '700 बोरी',
      date: 'आज, 26 अक्टूबर',
      icon: 'assets/json/crops.json',
    ),
  ];

  List<MandiRateModel> get mandiRates =>
      List.unmodifiable(_liveRates ?? _mandiRates);

  final List<RateAlertModel> _rateAlerts = [];

  List<RateAlertModel> get rateAlerts => List.unmodifiable(_rateAlerts);

  Future<void> addRateAlert(RateAlertModel alert) async {
    if (FarmerApi.configured) {
      await FarmerApi.post('/rate-alerts', {
        'id': alert.id,
        'cropName': alert.cropName,
        'cropHindi': alert.cropHindi,
        'mandiName': alert.mandiName,
        'targetPrice': alert.targetPrice,
        'isAbove': alert.isAbove,
        'isActive': alert.isActive,
      });
    }
    _rateAlerts.insert(0, alert);
    notifyListeners();
  }

  Future<void> toggleRateAlert(String id) async {
    final index = _rateAlerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      if (FarmerApi.configured)
        await FarmerApi.post('/rate-alerts/$id', {
          'isActive': !_rateAlerts[index].isActive,
        });
      _rateAlerts[index] = _rateAlerts[index].copyWith(
        isActive: !_rateAlerts[index].isActive,
      );
      notifyListeners();
    }
  }

  Future<void> removeRateAlert(String id) async {
    if (FarmerApi.configured)
      await FarmerApi.post('/rate-alerts/$id', {'deleted': true});
    _rateAlerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // --- Kisan Khata (Kharcha / Kamai) ---
  final List<KhataEntryModel> _khataEntries = [];

  List<KhataEntryModel> get khataEntries => List.unmodifiable(_khataEntries);

  double get totalKharcha => _khataEntries
      .where((e) => e.isKharcha)
      .fold(0.0, (sum, e) => sum + e.amount);

  double get totalKamai => _khataEntries
      .where((e) => e.isKamai)
      .fold(0.0, (sum, e) => sum + e.amount);

  double get netMunafa => totalKamai - totalKharcha;

  void addKhataEntry(KhataEntryModel entry) {
    _khataEntries.insert(0, entry);
    notifyListeners();
  }

  void deleteKhataEntry(String id) {
    _khataEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Smart Voice Input Parser:
  /// Parses spoken Hindi/Hinglish sentences into a KhataEntryModel.
  KhataEntryModel parseVoiceInput(String spokenText) {
    final lower = spokenText.toLowerCase();

    // Determine Type
    KhataType type = KhataType.kharcha;
    if (lower.contains('बेचा') ||
        lower.contains('बिक्री') ||
        lower.contains('कमाई') ||
        lower.contains('becha') ||
        lower.contains('bikri') ||
        lower.contains('kamai') ||
        lower.contains('aaye') ||
        lower.contains('mila') ||
        lower.contains('sold') ||
        lower.contains('income')) {
      type = KhataType.kamai;
    }

    // Determine Category
    String category = 'अन्य';
    if (lower.contains('dap') ||
        lower.contains('यूरिया') ||
        lower.contains('urea') ||
        lower.contains('खाद') ||
        lower.contains('khaad')) {
      category = 'खाद व उर्वरक';
    } else if (lower.contains('beej') ||
        lower.contains('बीज') ||
        lower.contains('seed')) {
      category = 'बीज (Seeds)';
    } else if (lower.contains('diesel') ||
        lower.contains('डीजल') ||
        lower.contains('tractor') ||
        lower.contains('ट्रैक्टर')) {
      category = 'डीजल व मशीन';
    } else if (lower.contains('majdoor') ||
        lower.contains('मजदूर') ||
        lower.contains('मजदूरी') ||
        lower.contains('labour')) {
      category = 'मजदूरी (Labour)';
    } else if (lower.contains('dawai') ||
        lower.contains('दवा') ||
        lower.contains('spray') ||
        lower.contains('कीटनाशक') ||
        lower.contains('keetnashak')) {
      category = 'कीटनाशक व स्प्रे';
    } else if (lower.contains('sinchai') ||
        lower.contains('सिंचाई') ||
        lower.contains('paani') ||
        lower.contains('बिजली')) {
      category = 'सिंचाई व बिजली';
    } else if (lower.contains('gehu') ||
        lower.contains('गेहूं') ||
        lower.contains('chana') ||
        lower.contains('चना') ||
        lower.contains('sarson') ||
        lower.contains('सरसों') ||
        lower.contains('crop')) {
      category = 'फसल बिक्री';
    } else if (lower.contains('doodh') ||
        lower.contains('दूध') ||
        lower.contains('milk')) {
      category = 'दूध बिक्री';
      if (lower.contains('बिक्री') ||
          lower.contains('sold') ||
          lower.contains('becha')) {
        type = KhataType.kamai;
      }
    }

    // Prefer an explicit currency amount, never the quantity of bags/quintals.
    var normalized = spokenText.replaceAll(',', '');
    const digits = '०१२३४५६७८९';
    for (var i = 0; i < digits.length; i++) {
      normalized = normalized.replaceAll(digits[i], '$i');
    }
    final currency = RegExp(
      r'(?:₹|rs\.?|inr)\s*(\d+(?:\.\d+)?)|(?:(\d+(?:\.\d+)?)\s*(?:रुपये|रुपए|रुपया|rupees|rupaye|rs))',
      caseSensitive: false,
    ).firstMatch(normalized);
    final numbers = RegExp(r'\d+(?:\.\d+)?').allMatches(normalized).toList();
    final amount = double.tryParse(
      currency?.group(1) ??
          currency?.group(2) ??
          (numbers.isEmpty ? '' : numbers.last.group(0)!),
    );
    if (amount == null || !amount.isFinite || amount <= 0) {
      throw const FormatException('सही रकम लिखें, जैसे खाद 2700 रुपये');
    }

    final entry = KhataEntryModel(
      id: 'khata_${DateTime.now().microsecondsSinceEpoch}',
      title: spokenText,
      category: category,
      amount: amount,
      type: type,
      date: DateTime.now(),
      note: 'बोलकर दर्ज किया गया (Voice entry)',
      isVoiceEntry: true,
      voiceTranscript: spokenText,
    );

    addKhataEntry(entry);
    return entry;
  }

  WeatherAdvisoryModel? _liveWeather;
  List<MandiRateModel>? _liveRates;
  String? feedError;
  String? feedUpdatedAt;
  bool loadingFeed = false;
  bool get hasLiveFeed => _liveWeather != null && _liveRates != null;
  String get feedStatus => hasLiveFeed
      ? 'Provider data • $feedUpdatedAt'
      : (feedError ?? 'उदाहरण डेटा • Live provider connect नहीं है');

  Future<void> refreshFeed() async {
    if (!FarmerApi.configured || loadingFeed) return;
    loadingFeed = true;
    super.notifyListeners();
    try {
      final data = await FarmerApi.get(
        '/daily-feed?district=${Uri.encodeQueryComponent(_district)}&mandi=${Uri.encodeQueryComponent(_selectedMandi)}',
      );
      final weather = WeatherAdvisoryModel.fromJson(
        Map<String, dynamic>.from(data['weather']),
      );
      final rates = (data['rates'] as List)
          .map(
            (e) => MandiRateModel(
              id: e['id'],
              mandiName: e['mandiName'],
              district: e['district'],
              state: e['state'],
              cropName: e['cropName'],
              cropHindi: e['cropHindi'],
              variety: e['variety'],
              minPrice: (e['minPrice'] as num).toDouble(),
              modalPrice: (e['modalPrice'] as num).toDouble(),
              maxPrice: (e['maxPrice'] as num).toDouble(),
              priceChange: (e['priceChange'] as num).toDouble(),
              arrival: e['arrival'],
              date: e['date'],
              icon: 'assets/json/crops.json',
            ),
          )
          .toList();
      _liveWeather = weather;
      _liveRates = rates;
      feedUpdatedAt = data['updatedAt'] as String;
      feedError = null;
    } on Object {
      _liveWeather = null;
      _liveRates = null;
      feedError =
          'Live data नहीं मिला • नीचे उदाहरण डेटा है। Refresh करके फिर जांचें।';
    } finally {
      loadingFeed = false;
      super.notifyListeners();
    }
  }

  // --- Weather & Agricultural Advisory Data ---
  WeatherAdvisoryModel get weatherAdvisory =>
      _liveWeather ??
      WeatherAdvisoryModel(
        location: 'नीमच, मध्य प्रदेश',
        temperature: 27,
        feelsLike: 29,
        condition: 'धूप व हल्का बादल (Partly Sunny)',
        highTemp: 31,
        lowTemp: 19,
        humidity: 58,
        windSpeed: 9,
        rainProbability: 10,
        todaySpraySuitability: SpraySuitability.safe,
        sprayAdviceTitle: 'आज स्प्रे के लिए उत्तम दिन है (Safe to Spray)',
        sprayAdviceDescription:
            'हवा की गति 9 km/h अनुकूल है और बारिश की केवल 10% संभावना है। सुबह के समय छिड़काव सबसे प्रभावी रहेगा।',
        bestSprayWindow: 'सुबह 7:30 AM से 10:30 AM या शाम 4:30 PM के बाद',
        irrigationAdviceTitle: 'सिंचाई सलाह: अभी हल्की सिंचाई कर सकते हैं',
        irrigationAdviceDescription:
            'अगले 4 दिनों तक बारिश के आसार नहीं हैं। गेहूं में पहली सिंचाई (CRI अवस्था) का सही समय है।',
        hourlyForecasts: const [
          HourlyForecast(
            time: '06:00 AM',
            temp: 20,
            rainChance: 5,
            humidity: 75,
            windSpeed: 6,
            condition: 'हल्का कोहरा',
            spraySuitability: SpraySuitability.safe,
            sprayNote: 'ओस सूखने का इंतज़ार करें',
          ),
          HourlyForecast(
            time: '09:00 AM',
            temp: 24,
            rainChance: 10,
            humidity: 62,
            windSpeed: 8,
            condition: 'खिली धूप',
            spraySuitability: SpraySuitability.safe,
            sprayNote: 'स्प्रे के लिए सर्वोत्तम समय',
          ),
          HourlyForecast(
            time: '12:00 PM',
            temp: 29,
            rainChance: 10,
            humidity: 45,
            windSpeed: 12,
            condition: 'तेज धूप',
            spraySuitability: SpraySuitability.caution,
            sprayNote: 'दवा वाष्पीकरण हो सकती है',
          ),
          HourlyForecast(
            time: '03:00 PM',
            temp: 31,
            rainChance: 15,
            humidity: 40,
            windSpeed: 14,
            condition: 'धूप व बादल',
            spraySuitability: SpraySuitability.caution,
            sprayNote: 'हवा की गति बढ़ सकती है',
          ),
          HourlyForecast(
            time: '06:00 PM',
            temp: 26,
            rainChance: 10,
            humidity: 55,
            windSpeed: 7,
            condition: 'शांत मौसम',
            spraySuitability: SpraySuitability.safe,
            sprayNote: 'शाम का स्प्रे अनुकूल',
          ),
          HourlyForecast(
            time: '09:00 PM',
            temp: 22,
            rainChance: 5,
            humidity: 68,
            windSpeed: 5,
            condition: 'साफ़ रात',
            spraySuitability: SpraySuitability.safe,
            sprayNote: 'मौसम शांत',
          ),
        ],
        dailyForecasts: const [
          DailyForecast(
            day: 'आज (सोम)',
            date: '26 Oct',
            highTemp: 31,
            lowTemp: 19,
            rainChance: 10,
            condition: 'धूप',
            spraySuitability: SpraySuitability.safe,
            irrigationAdvice: 'सिंचाई जारी रखें',
          ),
          DailyForecast(
            day: 'कल (मंगल)',
            date: '27 Oct',
            highTemp: 30,
            lowTemp: 18,
            rainChance: 15,
            condition: 'हल्के बादल',
            spraySuitability: SpraySuitability.safe,
            irrigationAdvice: 'हल्की सिंचाई अनुकूल',
          ),
          DailyForecast(
            day: 'बुधवार',
            date: '28 Oct',
            highTemp: 29,
            lowTemp: 18,
            rainChance: 20,
            condition: 'धूप',
            spraySuitability: SpraySuitability.safe,
            irrigationAdvice: 'सिंचाई कर सकते हैं',
          ),
          DailyForecast(
            day: 'गुरुवार',
            date: '29 Oct',
            highTemp: 28,
            lowTemp: 17,
            rainChance: 45,
            condition: 'बादल व हवा',
            spraySuitability: SpraySuitability.caution,
            irrigationAdvice: 'सिंचाई रोकें, बारिश की संभावना',
          ),
          DailyForecast(
            day: 'शुक्रवार',
            date: '30 Oct',
            highTemp: 27,
            lowTemp: 17,
            rainChance: 30,
            condition: 'हल्की फुहार',
            spraySuitability: SpraySuitability.unsafe,
            irrigationAdvice: 'सिंचाई न करें',
          ),
        ],
        cropSprayTips: const [
          CropSprayTip(
            cropName: 'Wheat',
            cropHindi: 'गेहूं (Wheat)',
            pestOrDisease: 'चौड़ी पत्ती खरपतवार (Bathua / Motha)',
            recommendation: 'बुवाई के 30-35 दिन बाद पहली सिंचाई के बाद करें।',
            medicine: '2,4-D Ethyl Ester या Metsulfuron',
            dosage: '20 ग्राम प्रति एकड़ 150 लीटर पानी में',
          ),
          CropSprayTip(
            cropName: 'Mustard',
            cropHindi: 'सरसों (Mustard)',
            pestOrDisease: 'माहू / चेपा कीट (Aphids)',
            recommendation:
                'फूल आने से पहले पत्तियों के नीचे कीट दिखने पर तुरंत स्प्रे करें।',
            medicine: 'Imidacloprid 17.8% SL या Thiamethoxam',
            dosage: '50-60 ml प्रति एकड़ 150 लीटर पानी में',
          ),
          CropSprayTip(
            cropName: 'Gram',
            cropHindi: 'चना (Gram/Chana)',
            pestOrDisease: 'इल्ली / फली छेदक (Helicoverpa)',
            recommendation:
                'फूल आने की शुरुआत में नीम तेल या फेरोमोन ट्रैप लगाएं।',
            medicine: 'Emamectin Benzoate 5% SG',
            dosage: '80 ग्राम प्रति एकड़ 150 लीटर पानी में',
          ),
        ],
      );

  SharedPreferences? _prefs;
  Future<void> _pendingSave = Future.value();
  Future<void> flush() => _pendingSave;
  String _storageKey = 'farmer_state_v1';
  Future<void> useAccount(String? id) async {
    await flush();
    _storageKey = 'farmer_state_v1_${id ?? "signed_out"}';
    _name = 'किसान';
    _phone = '';
    _village = '';
    _district = 'नीमच';
    _state = 'मध्य प्रदेश';
    _language = 'हिंदी (Hindi)';
    _landArea = '';
    _selectedCrops = ['गेहूं (Wheat)', 'चना (Chana)'];
    _isProfileCompleted = false;
    _khataEntries.clear();
    _rateAlerts.clear();
    _selectedMandi = 'नीमच मंडी';
    _liveWeather = null;
    _liveRates = null;
    feedError = null;
    feedUpdatedAt = null;
    await init();
    super.notifyListeners();
  }

  void applyServerProfile(Map<String, dynamic> data) {
    _name = data['name'] as String;
    _phone = data['phone'] as String? ?? '';
    _village = data['village'] as String? ?? '';
    _district = (data['district'] as String? ?? '').isEmpty
        ? 'नीमच'
        : data['district'];
    _state = data['state'] as String? ?? 'मध्य प्रदेश';
    _language = data['language'] as String? ?? 'हिंदी (Hindi)';
    _landArea = data['landArea'] as String? ?? '';
    final crops = List<String>.from(data['selectedCrops'] ?? []);
    if (crops.isNotEmpty) _selectedCrops = crops;
    _isProfileCompleted = data['profileCompleted'] == true;
    notifyListeners();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_storageKey);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _name = data['name'] ?? _name;
      _phone = data['phone'] ?? _phone;
      _village = data['village'] ?? _village;
      _district = data['district'] ?? _district;
      _state = data['state'] ?? _state;
      _language = data['language'] ?? _language;
      _landArea = data['landArea'] ?? _landArea;
      _isProfileCompleted = data['completed'] ?? false;
      _selectedCrops = List<String>.from(data['crops'] ?? _selectedCrops);
      _selectedMandi = data['mandi'] ?? _selectedMandi;
      _khataEntries.clear();
      for (final e in data['entries'] ?? []) {
        _khataEntries.add(
          KhataEntryModel(
            id: e['id'],
            title: e['title'],
            category: e['category'],
            amount: (e['amount'] as num).toDouble(),
            type: KhataType.values.byName(e['type']),
            date: DateTime.parse(e['date']),
            note: e['note'],
            cropTag: e['cropTag'],
            isVoiceEntry: e['voice'] ?? false,
            voiceTranscript: e['transcript'],
          ),
        );
      }
      _rateAlerts.clear();
      for (final e in data['alerts'] ?? []) {
        _rateAlerts.add(
          RateAlertModel(
            id: e['id'],
            cropName: e['cropName'],
            cropHindi: e['cropHindi'],
            mandiName: e['mandiName'],
            targetPrice: (e['targetPrice'] as num).toDouble(),
            isAbove: e['isAbove'],
            isActive: e['isActive'],
            createdAt: e['createdAt'],
          ),
        );
      }
    } on Object catch (error) {
      debugPrint('Could not restore farmer data: $error');
    }
  }

  @override
  void notifyListeners() {
    final data = jsonEncode({
      'name': _name,
      'phone': _phone,
      'village': _village,
      'district': _district,
      'state': _state,
      'language': _language,
      'landArea': _landArea,
      'completed': _isProfileCompleted,
      'crops': _selectedCrops,
      'mandi': _selectedMandi,
      'entries': _khataEntries
          .map(
            (e) => {
              'id': e.id,
              'title': e.title,
              'category': e.category,
              'amount': e.amount,
              'type': e.type.name,
              'date': e.date.toIso8601String(),
              'note': e.note,
              'cropTag': e.cropTag,
              'voice': e.isVoiceEntry,
              'transcript': e.voiceTranscript,
            },
          )
          .toList(),
      'alerts': _rateAlerts
          .map(
            (e) => {
              'id': e.id,
              'cropName': e.cropName,
              'cropHindi': e.cropHindi,
              'mandiName': e.mandiName,
              'targetPrice': e.targetPrice,
              'isAbove': e.isAbove,
              'isActive': e.isActive,
              'createdAt': e.createdAt,
            },
          )
          .toList(),
    });
    final storageKey = _storageKey;
    _pendingSave = _pendingSave.then((_) async {
      await _prefs?.setString(storageKey, data);
    });
    super.notifyListeners();
  }
}
