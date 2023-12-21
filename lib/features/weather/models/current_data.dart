class Condition {
  late String text;
  late String icon;
  late int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }
}

class CurrentData {
  late double tempC;
  // late double tempF;
  // // late double isDay;
  late Condition condition;
  late double windKph;
  late int humidity;

  CurrentData({
    required this.tempC,
    required this.condition,
    required this.windKph,
    required this.humidity,
  });

  factory CurrentData.fromJson(Map<String, dynamic> json) {
    return CurrentData(
      tempC: json['temp_c'],
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'],
      humidity: json['humidity'],
    );
  }
}

class CurrentWeatherResponse {
  late CurrentData currentData;
  late String locationName;
  late int weatherCode;

  CurrentWeatherResponse({
    required this.currentData,
    required this.locationName,
    required this.weatherCode,
  });

  factory CurrentWeatherResponse.fromJson(Map<String, dynamic> json) {
    print('weather code: ${json['current']['condition']['code']}');
    return CurrentWeatherResponse(
      currentData: CurrentData.fromJson(json['current']),
      locationName: json['location']['name'],
      weatherCode: json['current']['condition']['code'].toInt(),
    );
  }
}
