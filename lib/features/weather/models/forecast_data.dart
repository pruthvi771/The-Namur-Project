class ForecastWeatherResponse {
  late Map<String, dynamic> responseData;

  ForecastWeatherResponse.fromJson(Map<String, dynamic> json) {
    var currentData = json['current'];
    var forecastData = json['forecast']['forecastday'];

    responseData = {
      'name': json['location']['name'],
      'current data': {
        'date': currentData['last_updated'],
        'humidity': currentData['humidity'],
        'windspeed': currentData['wind_kph'],
        'temperature': currentData['temp_c'],
        'description': currentData['condition']['text'],
        'code': currentData['condition']['code'],
      },
      'day0': {
        'date': forecastData[0]['date'],
        'mintemp': forecastData[0]['day']['mintemp_c'],
        'maxtemp': forecastData[0]['day']['maxtemp_c'],
        'desc': forecastData[0]['day']['condition']['text'],
        'code': forecastData[0]['day']['condition']['code'],
      },
      'day1': {
        'date': forecastData[1]['date'],
        'mintemp': forecastData[1]['day']['mintemp_c'],
        'maxtemp': forecastData[1]['day']['maxtemp_c'],
        'desc': forecastData[1]['day']['condition']['text'],
        'code': forecastData[1]['day']['condition']['code'],
      },
      'day2': {
        'date': forecastData[2]['date'],
        'mintemp': forecastData[2]['day']['mintemp_c'],
        'maxtemp': forecastData[2]['day']['maxtemp_c'],
        'desc': forecastData[2]['day']['condition']['text'],
        'code': forecastData[2]['day']['condition']['code'],
      },
    };
  }

  dynamic operator [](String key) {
    // Implement the [] operator to access properties in responseData
    return responseData[key];
  }
}
