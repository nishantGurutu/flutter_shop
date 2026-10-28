enum SpraySuitability { safe, caution, unsafe }

class HourlyForecast {
  final String time;
  final int temp;
  final int rainChance;
  final int humidity;
  final int windSpeed;
  final String condition;
  final SpraySuitability spraySuitability;
  final String sprayNote;

  const HourlyForecast({
    required this.time,
    required this.temp,
    required this.rainChance,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.spraySuitability,
    required this.sprayNote,
  });
}

class DailyForecast {
  final String day;
  final String date;
  final int highTemp;
  final int lowTemp;
  final int rainChance;
  final String condition;
  final SpraySuitability spraySuitability;
  final String irrigationAdvice;

  const DailyForecast({
    required this.day,
    required this.date,
    required this.highTemp,
    required this.lowTemp,
    required this.rainChance,
    required this.condition,
    required this.spraySuitability,
    required this.irrigationAdvice,
  });
}

class CropSprayTip {
  final String cropName;
  final String cropHindi;
  final String pestOrDisease;
  final String recommendation;
  final String medicine;
  final String dosage;

  const CropSprayTip({
    required this.cropName,
    required this.cropHindi,
    required this.pestOrDisease,
    required this.recommendation,
    required this.medicine,
    required this.dosage,
  });
}

class WeatherAdvisoryModel {
  final String location;
  final int temperature;
  final int feelsLike;
  final String condition;
  final int highTemp;
  final int lowTemp;
  final int humidity;
  final int windSpeed;
  final int rainProbability;
  final SpraySuitability todaySpraySuitability;
  final String sprayAdviceTitle;
  final String sprayAdviceDescription;
  final String bestSprayWindow;
  final String irrigationAdviceTitle;
  final String irrigationAdviceDescription;
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;
  final List<CropSprayTip> cropSprayTips;

  factory WeatherAdvisoryModel.fromJson(Map<String, dynamic> j) {
    SpraySuitability suitability(dynamic value) =>
        SpraySuitability.values.byName(value as String);
    int number(String key) => (j[key] as num).round();
    return WeatherAdvisoryModel(
      location: j['location'],
      temperature: number('temperature'),
      feelsLike: number('feelsLike'),
      condition: j['condition'],
      highTemp: number('highTemp'),
      lowTemp: number('lowTemp'),
      humidity: number('humidity'),
      windSpeed: number('windSpeed'),
      rainProbability: number('rainProbability'),
      todaySpraySuitability: suitability(j['todaySpraySuitability']),
      sprayAdviceTitle: j['sprayAdviceTitle'],
      sprayAdviceDescription: j['sprayAdviceDescription'],
      bestSprayWindow: j['bestSprayWindow'],
      irrigationAdviceTitle: j['irrigationAdviceTitle'],
      irrigationAdviceDescription: j['irrigationAdviceDescription'],
      hourlyForecasts: (j['hourlyForecasts'] as List? ?? [])
          .map(
            (e) => HourlyForecast(
              time: e['time'],
              temp: (e['temp'] as num).round(),
              rainChance: (e['rainChance'] as num).round(),
              humidity: (e['humidity'] as num).round(),
              windSpeed: (e['windSpeed'] as num).round(),
              condition: e['condition'],
              spraySuitability: suitability(e['spraySuitability']),
              sprayNote: e['sprayNote'],
            ),
          )
          .toList(),
      dailyForecasts: (j['dailyForecasts'] as List? ?? [])
          .map(
            (e) => DailyForecast(
              day: e['day'],
              date: e['date'],
              highTemp: (e['highTemp'] as num).round(),
              lowTemp: (e['lowTemp'] as num).round(),
              rainChance: (e['rainChance'] as num).round(),
              condition: e['condition'],
              spraySuitability: suitability(e['spraySuitability']),
              irrigationAdvice: e['irrigationAdvice'],
            ),
          )
          .toList(),
      cropSprayTips: (j['cropSprayTips'] as List? ?? [])
          .map(
            (e) => CropSprayTip(
              cropName: e['cropName'],
              cropHindi: e['cropHindi'],
              pestOrDisease: e['pestOrDisease'],
              recommendation: e['recommendation'],
              medicine: e['medicine'],
              dosage: e['dosage'],
            ),
          )
          .toList(),
    );
  }

  const WeatherAdvisoryModel({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.highTemp,
    required this.lowTemp,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.todaySpraySuitability,
    required this.sprayAdviceTitle,
    required this.sprayAdviceDescription,
    required this.bestSprayWindow,
    required this.irrigationAdviceTitle,
    required this.irrigationAdviceDescription,
    required this.hourlyForecasts,
    required this.dailyForecasts,
    required this.cropSprayTips,
  });
}
