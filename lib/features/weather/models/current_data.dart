// class CurrentData {
//   final String date;
//   final double currentTemp;
//   final String desc;
//   final double humidity;
//   final double windSpeed;

//   const CurrentData({
//     required this.date,
//     required this.currentTemp,
//     required this.desc,
//     required this.humidity,
//     required this.windSpeed,
//   });

//   factory CurrentData.fromJson(Map<String, dynamic> json) {
//     return CurrentData(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }

// class ResponseData {
//   final String currentDate;
//   final double currentTemp;
//   final String currentDesc;
//   final double currentHumidity;
//   final double currentWindSpeed;

//   final String date0;
//   final double maxTemp0;
//   final double minTemp0;
//   final String desc0;

//   final String date1;
//   final double maxTemp1;
//   final double minTemp1;
//   final String desc1;

//   final String date2;
//   final double maxTemp2;
//   final double minTemp2;
//   final String desc2;

//   const ResponseData({
//     required this.date0,
//     required this.maxTemp0,
//     required this.minTemp0,
//     required this.desc0,
//     required this.date1,
//     required this.maxTemp1,
//     required this.minTemp1,
//     required this.desc1,
//     required this.date2,
//     required this.maxTemp2,
//     required this.minTemp2,
//     required this.desc2,
//     required this.currentDate,
//     required this.currentTemp,
//     required this.currentDesc,
//     required this.currentHumidity,
//     required this.currentWindSpeed,
//   });

//   factory ResponseData.fromJson(Map<String, dynamic> json) {
//     return ResponseData(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }

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
  // late int lastUpdatedEpoch;
  // late String lastUpdated;
  late double tempC;
  // late double tempF;
  // // late double isDay;
  late Condition condition;
  // late double windMph;
  late double windKph;
  // late int windDegree;
  // late String windDir;
  // late double pressureMb;
  // late double pressureIn;
  // late double precipMm;
  // late double precipIn;
  late int humidity;
  // late int cloud;
  // late double feelslikeC;
  // late double feelslikeF;
  // late int visKm;
  // late int visMiles;
  // late int uv;
  // late double gustMph;
  // late double gustKph;

  CurrentData({
    // required this.lastUpdatedEpoch,
    // required this.lastUpdated,
    required this.tempC,
    // required this.tempF,
    // required this.isDay,
    required this.condition,
    // required this.windMph,
    required this.windKph,
    // required this.windDegree,
    // required this.windDir,
    // required this.pressureMb,
    // required this.pressureIn,
    // required this.precipMm,
    // required this.precipIn,
    required this.humidity,
    // required this.cloud,
    // required this.feelslikeC,
    // required this.feelslikeF,
    // required this.visKm,
    // required this.visMiles,
    // required this.uv,
    // required this.gustMph,
    // required this.gustKph,
  });

  factory CurrentData.fromJson(Map<String, dynamic> json) {
    return CurrentData(
      // lastUpdatedEpoch: json['last_updated_epoch'],
      // lastUpdated: json['last_updated'],
      tempC: json['temp_c'],
      // tempF: json['temp_f'],
      // isDay: json['is_day'],
      condition: Condition.fromJson(json['condition']),
      // windMph: json['wind_mph'],
      windKph: json['wind_kph'],
      // windDegree: json['wind_degree'],
      // windDir: json['wind_dir'],
      // pressureMb: json['pressure_mb'],
      // pressureIn: json['pressure_in'],
      // precipMm: json['precip_mm'],
      // precipIn: json['precip_in'],
      humidity: json['humidity'],
      // cloud: json['cloud'],
      // feelslikeC: json['feelslike_c'],
      // feelslikeF: json['feelslike_f'],
      // visKm: json['vis_km'],
      // visMiles: json['vis_miles'],
      // uv: json['uv'],
      // gustMph: json['gust_mph'],
      // gustKph: json['gust_kph'],
    );
  }
}

class CurrentWeatherResponse {
  late CurrentData currentData;

  CurrentWeatherResponse({
    required this.currentData,
  });

  factory CurrentWeatherResponse.fromJson(Map<String, dynamic> json) {
    print('hey ');
    return CurrentWeatherResponse(
      currentData: CurrentData.fromJson(json['current']),
    );
  }
}
