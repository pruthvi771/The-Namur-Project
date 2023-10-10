import 'dart:async';
import 'dart:convert';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/weather/models/current_data.dart';
import 'package:active_ecommerce_flutter/features/weather/models/forecast_data.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/features/weather/constants.dart';

class WeatherRepository {
  Future<ForecastWeatherResponse> fetchForecast() async {
    var dataBox = Hive.box<PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData == null) {
      throw Exception('No Location Data Found. Please allow location access.');
    } else {
      final response = await http.get(Uri.parse(
          '$BASE_URL/forecast.json?key=$API_KEY&q=${savedData.latitude},${savedData.longitude}&days=3&aqi=no&alerts=no'));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ForecastWeatherResponse.fromJson(jsonResponse);
      } else {
        print('error happened in forecast');
        throw Exception('Failed to load album');
      }
    }

    // final response = await http.get(Uri.parse(
    //     '$BASE_URL/forecast.json?key=$API_KEY&q=48.8567,2.3508&days=3&aqi=no&alerts=no'));
    //   if (response.statusCode == 200) {
    //     var jsonResponse = json.decode(response.body);
    //     return ForecastWeatherResponse.fromJson(jsonResponse);
    //   } else {
    //     print('error happened in forecast');
    //     throw Exception('Failed to load album');
    //   }
  }

  Future<CurrentWeatherResponse> fetchCurrent() async {
    var dataBox = Hive.box<PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData == null) {
      // print("saved Latitude: ${savedData.latitude}");
      // print("saved Longitude: ${savedData.longitude}");
      // return;
      throw Exception('No Location Data Found. Please allow location access.');
    } else {
      final response = await http.get(Uri.parse(
          '$BASE_URL/current.json?key=$API_KEY&q=${savedData.latitude},${savedData.longitude}&aqi=no'));

      if (response.statusCode == 200) {
        // print('I am here');
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return CurrentWeatherResponse.fromJson(jsonResponse);
      } else {
        print('error happened in current weather');
        throw Exception('Failed to load album');
      }
    }
  }
}
