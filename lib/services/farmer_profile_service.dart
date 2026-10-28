import 'package:flutter/foundation.dart';
import 'package:shop/model/khata_model.dart';
import 'package:shop/model/mandi_model.dart';
import 'package:shop/model/weather_advisory_model.dart';

class FarmerProfileService extends ChangeNotifier {
  static final FarmerProfileService _instance = FarmerProfileService._internal();
  factory FarmerProfileService() => _instance;

  FarmerProfileService._internal() {
    _initDefaultData();
  }

  // --- Farmer Profile State ---
  String _name = 'रामेश पटेल';
  String _phone = '+91 98765 43210';
  String _language = 'हिंदी (Hindi)';
  String _village = 'रामपुर कलां';
  String _district = 'नीमच';
  String _state = 'मध्य प्रदेश';
  String _landArea = '4.5 एकड़';
  List<String> _selectedCrops = ['गेहूं (Wheat)', 'चना (Chana)', 'सरसों (Mustard)'];
  bool _isProfileCompleted = true;

  String get name => _name;
  String get phone => _phone;
  String get language => _language;
  String get village => _village;
  String get district => _district;
  String get state => _state;
  String get landArea => _landArea;
  List<String> get selectedCrops => _selectedCrops;
  bool get isProfileCompleted => _isProfileCompleted;

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
    notifyListeners();
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
    notifyListeners();
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

  List<MandiRateModel> get mandiRates => _mandiRates;

  final List<RateAlertModel> _rateAlerts = [
    const RateAlertModel(
      id: 'ra_1',
      cropName: 'Wheat',
      cropHindi: 'गेहूं',
      mandiName: 'नीमच मंडी',
      targetPrice: 2700,
      isAbove: true,
      isActive: true,
      createdAt: '24 Oct 2026',
    ),
    const RateAlertModel(
      id: 'ra_2',
      cropName: 'Mustard',
      cropHindi: 'सरसों',
      mandiName: 'नीमच मंडी',
      targetPrice: 5800,
      isAbove: true,
      isActive: true,
      createdAt: '22 Oct 2026',
    ),
  ];

  List<RateAlertModel> get rateAlerts => _rateAlerts;

  void addRateAlert(RateAlertModel alert) {
    _rateAlerts.insert(0, alert);
    notifyListeners();
  }

  void toggleRateAlert(String id) {
    final index = _rateAlerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _rateAlerts[index] = _rateAlerts[index].copyWith(
        isActive: !_rateAlerts[index].isActive,
      );
      notifyListeners();
    }
  }

  void removeRateAlert(String id) {
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
    if (lower.contains('becha') ||
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
    if (lower.contains('dap') || lower.contains('यूरिया') || lower.contains('urea') || lower.contains('खाद') || lower.contains('khaad')) {
      category = 'खाद व उर्वरक';
    } else if (lower.contains('beej') || lower.contains('बीज') || lower.contains('seed')) {
      category = 'बीज (Seeds)';
    } else if (lower.contains('diesel') || lower.contains('डीजल') || lower.contains('tractor') || lower.contains('ट्रैक्टर')) {
      category = 'डीजल व मशीन';
    } else if (lower.contains('majdoor') || lower.contains('मजदूर') || lower.contains('मजदूरी') || lower.contains('labour')) {
      category = 'मजदूरी (Labour)';
    } else if (lower.contains('dawai') || lower.contains('दवा') || lower.contains('spray') || lower.contains('कीटनाशक') || lower.contains('keetnashak')) {
      category = 'कीटनाशक व स्प्रे';
    } else if (lower.contains('sinchai') || lower.contains('सिंचाई') || lower.contains('paani') || lower.contains('बिजली')) {
      category = 'सिंचाई व बिजली';
    } else if (lower.contains('gehu') || lower.contains('गेहूं') || lower.contains('chana') || lower.contains('चना') || lower.contains('sarson') || lower.contains('सरसों') || lower.contains('crop')) {
      category = 'फसल बिक्री';
      type = KhataType.kamai;
    } else if (lower.contains('doodh') || lower.contains('दूध') || lower.contains('milk')) {
      category = 'दूध बिक्री';
      type = KhataType.kamai;
    }

    // Extract Amount (number)
    final numRegExp = RegExp(r'\d+');
    final match = numRegExp.firstMatch(spokenText.replaceAll(',', ''));
    double amount = 500;
    if (match != null) {
      amount = double.tryParse(match.group(0) ?? '') ?? 500;
    }

    final entry = KhataEntryModel(
      id: 'khata_${DateTime.now().millisecondsSinceEpoch}',
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

  // --- Weather & Agricultural Advisory Data ---
  WeatherAdvisoryModel get weatherAdvisory => WeatherAdvisoryModel(
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
            recommendation: 'फूल आने से पहले पत्तियों के नीचे कीट दिखने पर तुरंत स्प्रे करें।',
            medicine: 'Imidacloprid 17.8% SL या Thiamethoxam',
            dosage: '50-60 ml प्रति एकड़ 150 लीटर पानी में',
          ),
          CropSprayTip(
            cropName: 'Gram',
            cropHindi: 'चना (Gram/Chana)',
            pestOrDisease: 'इल्ली / फली छेदक (Helicoverpa)',
            recommendation: 'फूल आने की शुरुआत में नीम तेल या फेरोमोन ट्रैप लगाएं।',
            medicine: 'Emamectin Benzoate 5% SG',
            dosage: '80 ग्राम प्रति एकड़ 150 लीटर पानी में',
          ),
        ],
      );

  void _initDefaultData() {
    // Populate realistic initial Khata entries
    _khataEntries.addAll([
      KhataEntryModel(
        id: 'init_1',
        title: '2 बोरी डीएपी (DAP) खाद',
        category: 'खाद व उर्वरक',
        amount: 2700,
        type: KhataType.kharcha,
        date: DateTime.now().subtract(const Duration(days: 1)),
        note: 'IFFCO DAP 50kg बैग',
      ),
      KhataEntryModel(
        id: 'init_2',
        title: 'ट्रैक्टर जुताई डीजल',
        category: 'डीजल व मशीन',
        amount: 1450,
        type: KhataType.kharcha,
        date: DateTime.now().subtract(const Duration(days: 2)),
        note: 'खेत की गहरी जुताई 15 लीटर',
      ),
      KhataEntryModel(
        id: 'init_3',
        title: '12 क्विंटल पुराना गेहूं बिक्री',
        category: 'फसल बिक्री',
        amount: 30600,
        type: KhataType.kamai,
        date: DateTime.now().subtract(const Duration(days: 4)),
        note: 'मंडी में ₹2,550/क्विंटल पर',
      ),
      KhataEntryModel(
        id: 'init_4',
        title: 'गेहूं बीज 40 kg (GW 322)',
        category: 'बीज (Seeds)',
        amount: 1600,
        type: KhataType.kharcha,
        date: DateTime.now().subtract(const Duration(days: 5)),
        note: 'प्रमाणित बीज',
      ),
      KhataEntryModel(
        id: 'init_5',
        title: 'दूध बिक्री साप्ताहिक भुगतान',
        category: 'दूध बिक्री',
        amount: 4200,
        type: KhataType.kamai,
        date: DateTime.now().subtract(const Duration(days: 6)),
        note: 'डेयरी कलेक्शन',
      ),
    ]);
  }
}
