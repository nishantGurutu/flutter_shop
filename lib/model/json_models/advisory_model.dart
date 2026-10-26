import 'package:equatable/equatable.dart';

class AdvisoryModel extends Equatable {
  final WeatherDataModel weather;
  final List<SmartTipModel> smartTips;
  final List<ExpertCategoryModel> expertCategories;
  final List<FaqModel> faq;

  const AdvisoryModel({
    required this.weather,
    required this.smartTips,
    required this.expertCategories,
    required this.faq,
  });

  factory AdvisoryModel.fromJson(Map<String, dynamic> json) {
    return AdvisoryModel(
      weather: WeatherDataModel.fromJson(json['weather'] as Map<String, dynamic>),
      smartTips: (json['smartTips'] as List)
          .map((e) => SmartTipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      expertCategories: (json['expertCategories'] as List)
          .map((e) => ExpertCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      faq: (json['faq'] as List)
          .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [weather, smartTips, expertCategories, faq];
}

class WeatherDataModel extends Equatable {
  final int temperature;
  final String condition;
  final String conditionHi;
  final int humidity;
  final int windSpeed;
  final String location;
  final List<ForecastDayModel> forecast;

  const WeatherDataModel({
    required this.temperature,
    required this.condition,
    required this.conditionHi,
    required this.humidity,
    required this.windSpeed,
    required this.location,
    required this.forecast,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      temperature: json['temperature'] as int,
      condition: json['condition'] as String,
      conditionHi: json['conditionHi'] as String,
      humidity: json['humidity'] as int,
      windSpeed: json['windSpeed'] as int,
      location: json['location'] as String,
      forecast: (json['forecast'] as List)
          .map((e) => ForecastDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [temperature, condition, conditionHi, humidity, windSpeed, location, forecast];
}

class ForecastDayModel extends Equatable {
  final String day;
  final int temp;
  final String condition;

  const ForecastDayModel({
    required this.day,
    required this.temp,
    required this.condition,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      day: json['day'] as String,
      temp: json['temp'] as int,
      condition: json['condition'] as String,
    );
  }

  @override
  List<Object?> get props => [day, temp, condition];
}

class SmartTipModel extends Equatable {
  final String id;
  final String title;
  final String titleHi;
  final String description;
  final String descriptionHi;
  final String buttonText;
  final String buttonTextHi;
  final String image;

  const SmartTipModel({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.description,
    required this.descriptionHi,
    required this.buttonText,
    required this.buttonTextHi,
    required this.image,
  });

  factory SmartTipModel.fromJson(Map<String, dynamic> json) {
    return SmartTipModel(
      id: json['id'] as String,
      title: json['title'] as String,
      titleHi: json['titleHi'] as String,
      description: json['description'] as String,
      descriptionHi: json['descriptionHi'] as String,
      buttonText: json['buttonText'] as String,
      buttonTextHi: json['buttonTextHi'] as String,
      image: json['image'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, titleHi, description, descriptionHi, buttonText, buttonTextHi, image];
}

class ExpertCategoryModel extends Equatable {
  final String id;
  final String title;
  final String titleHi;
  final String icon;
  final String color;

  const ExpertCategoryModel({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.icon,
    required this.color,
  });

  factory ExpertCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpertCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      titleHi: json['titleHi'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, titleHi, icon, color];
}

class FaqModel extends Equatable {
  final String question;
  final String questionHi;
  final String answer;
  final String answerHi;

  const FaqModel({
    required this.question,
    required this.questionHi,
    required this.answer,
    required this.answerHi,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] as String,
      questionHi: json['questionHi'] as String,
      answer: json['answer'] as String,
      answerHi: json['answerHi'] as String,
    );
  }

  @override
  List<Object?> get props => [question, questionHi, answer, answerHi];
}
