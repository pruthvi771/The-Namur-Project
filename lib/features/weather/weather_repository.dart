import 'dart:async';
import 'dart:convert';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/weather/models/current_data.dart';
import 'package:active_ecommerce_flutter/features/weather/models/forecast_data.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/features/weather/constants.dart';

class WeatherRepository {
  Future<List<ForecastWeatherResponse?>> fetchForecast() async {
    var dataBox = Hive.box<PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData == null) {
      return [null, null, null];
      // throw Exception('no-Location-data');
    } else {
      var primaryResponse;
      if (savedData.isAddress) {
        primaryResponse = await http.get(Uri.parse(
            '$BASE_URL/forecast.json?key=$API_KEY&q=${savedData.address}&days=3&aqi=no&alerts=no'));
      } else {
        primaryResponse = await http.get(Uri.parse(
            '$BASE_URL/forecast.json?key=$API_KEY&q=${savedData.latitude},${savedData.longitude}&days=3&aqi=no&alerts=no'));
      }

      var secondaryDataBox =
          Hive.box<SecondaryLocations>('secondaryLocationsBox');

      var secondarySavedData = secondaryDataBox.get('secondaryLocations');

      var secondaryResponseList = [];

      if (secondarySavedData == null) {
        secondaryResponseList = [null, null];
      } else if (secondarySavedData.address.length == 1) {
        var secondaryResponse = await http.get(Uri.parse(
            '$BASE_URL/forecast.json?key=$API_KEY&q=${secondarySavedData.address[0]}&days=3&aqi=no&alerts=no'));
        secondaryResponseList = [
          ForecastWeatherResponse.fromJson(json.decode(secondaryResponse.body)),
          null
        ];
      } else if (secondarySavedData.address.length == 2) {
        var secondaryResponse1 = await http.get(Uri.parse(
            '$BASE_URL/forecast.json?key=$API_KEY&q=${secondarySavedData.address[0]}&days=3&aqi=no&alerts=no'));

        var secondaryResponse2 = await http.get(Uri.parse(
            '$BASE_URL/forecast.json?key=$API_KEY&q=${secondarySavedData.address[1]}&days=3&aqi=no&alerts=no'));

        secondaryResponseList = [
          ForecastWeatherResponse.fromJson(
              json.decode(secondaryResponse1.body)),
          ForecastWeatherResponse.fromJson(
              json.decode(secondaryResponse2.body)),
        ];
      }

      // primaryResponse = await http.get(Uri.parse(
      //     '$BASE_URL/forecast.json?key=$API_KEY&q=${savedData.address}&days=3&aqi=no&alerts=no'));

      if (primaryResponse.statusCode == 200) {
        var jsonResponse = json.decode(primaryResponse.body);
        return [
          ForecastWeatherResponse.fromJson(jsonResponse),
          ...secondaryResponseList
        ];
      } else {
        throw Exception('Failed to load album');
      }
    }

    // final response = await http.get(Uri.parse(
    //     '$BASE_URL/forecast.json?key=$API_KEY&q=48.8567,2.3508&days=3&aqi=no&alerts=no'));
    //   if (response.statusCode == 200) {
    //     var jsonResponse = json.decode(response.body);
    //     return ForecastWeatherResponse.fromJson(jsonResponse);
    //   } else {
    //
    //     throw Exception('Failed to load album');
    //   }
  }

  Future<List<CurrentWeatherResponse?>> fetchCurrent() async {
    var dataBox = Hive.box<PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData == null) {
      return [null, null, null];
      // throw Exception('no-Location-data');
      //
      //
      // return;
    } else {
      var response;
      if (savedData.isAddress) {
        response = await http.get(Uri.parse(
            '$BASE_URL/current.json?key=$API_KEY&q=${savedData.address}&aqi=no'));
      } else {
        response = await http.get(Uri.parse(
            '$BASE_URL/current.json?key=$API_KEY&q=${savedData.latitude},${savedData.longitude}&aqi=no'));
      }

      var secondaryDataBox =
          Hive.box<SecondaryLocations>('secondaryLocationsBox');

      var secondarySavedData = secondaryDataBox.get('secondaryLocations');

      // if (secondarySavedData == null) {
      // } else {
      //   for (var secondaryDataBox in secondarySavedData.address) {}
      // }

      var secondaryCurrentResponseList = [];

      if (secondarySavedData == null) {
        secondaryCurrentResponseList = [null, null];
      } else if (secondarySavedData.address.length == 1) {
        var secondaryResponse = await http.get(Uri.parse(
            '$BASE_URL/current.json?key=$API_KEY&q=${secondarySavedData.address[0]}&aqi=no'));

        secondaryCurrentResponseList = [
          CurrentWeatherResponse.fromJson(json.decode(secondaryResponse.body)),
          null
        ];
      } else if (secondarySavedData.address.length == 2) {
        var secondaryResponse1 = await http.get(Uri.parse(
            '$BASE_URL/current.json?key=$API_KEY&q=${secondarySavedData.address[0]}&aqi=no'));

        var secondaryResponse2 = await http.get(Uri.parse(
            '$BASE_URL/current.json?key=$API_KEY&q=${secondarySavedData.address[1]}&aqi=no'));

        secondaryCurrentResponseList = [
          CurrentWeatherResponse.fromJson(json.decode(secondaryResponse1.body)),
          CurrentWeatherResponse.fromJson(json.decode(secondaryResponse2.body)),
        ];
      }

      if (response.statusCode == 200) {
        //
        var jsonResponse = json.decode(response.body);
        //
        return [
          CurrentWeatherResponse.fromJson(jsonResponse),
          ...secondaryCurrentResponseList
        ];
      } else {
        throw Exception('Failed to load album');
      }
    }
  }

  Future<String?> getNameFromLatLong(double lat, double long) async {
    var response;

    response = await http.get(Uri.parse(
        '$BASE_URL/current.json?key=$API_KEY&q=${lat.toString()},${long.toString()}&aqi=no'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['location']['name'];
    } else {
      return null;
      // throw Exception('Failed to load album');
    }
  }
}
