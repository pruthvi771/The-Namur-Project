import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/address_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_make_default_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_in_cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_location_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/shipping_cost_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';

class AddressRepository {
  Future<dynamic> getAddressList() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/address");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);
    //
    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressResponseFromJson(response.body);
  }

  Future<dynamic> getHomeDeliveryAddress() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-home-delivery-address");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);
    //

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressResponseFromJson(response.body);
  }

  Future<dynamic> getAddressAddResponse(
      {required String address,
      required int? countryId,
      required int? stateId,
      required int? cityId,
      required String postalCode,
      required String phone}) async {
    var postBody = jsonEncode({
      "user_id": "${user_id.$}",
      "address": "$address",
      "country_id": "$countryId",
      "state_id": "$stateId",
      "city_id": "$cityId",
      "postal_code": "$postalCode",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/create");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressAddResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateResponse(
      {required int? id,
      required String address,
      required int? countryId,
      required int? stateId,
      required int? cityId,
      required String postalCode,
      required String phone}) async {
    var postBody = jsonEncode({
      "id": "$id",
      "user_id": "${user_id.$}",
      "address": "$address",
      "country_id": "$countryId",
      "state_id": "$stateId",
      "city_id": "$cityId",
      "postal_code": "$postalCode",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/update");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressUpdateResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateLocationResponse(
    int? id,
    double? latitude,
    double? longitude,
  ) async {
    var postBody = jsonEncode({
      "id": "$id",
      "user_id": "${user_id.$}",
      "latitude": "$latitude",
      "longitude": "$longitude"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/update-location");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressUpdateLocationResponseFromJson(response.body);
  }

  Future<dynamic> getAddressMakeDefaultResponse(
    int? id,
  ) async {
    var postBody = jsonEncode({
      "id": "$id",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/make_default");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: postBody);
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<dynamic> getAddressDeleteResponse(
    int? id,
  ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/delete/$id");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCityListByState({stateId = 0, name = ""}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/cities-by-state/$stateId?name=$name");
    final response = await http.get(url);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return cityResponseFromJson(response.body);
  }

  Future<dynamic> getStateListByCountry({countryId = 0, name = ""}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/states-by-country/$countryId?name=$name");
    final response = await http.get(url);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return myStateResponseFromJson(response.body);
  }

  Future<dynamic> getCountryList({name = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/countries?name=$name");
    final response = await http.get(url);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return countryResponseFromJson(response.body);
  }

  Future<dynamic> getShippingCostResponse({shippingType = ""}) async {
    var postBody = jsonEncode({"seller_list": shippingType});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/shipping_cost");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
          "Currency-Code": SystemConfig.systemCurrency!.code!,
          "Currency-Exchange-Rate":
              SystemConfig.systemCurrency!.exchangeRate.toString(),
        },
        body: postBody);
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return shippingCostResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateInCartResponse(
      {int? addressId = 0, int pickupPointId = 0}) async {
    var postBody = jsonEncode({
      "address_id": "$addressId",
      "pickup_point_id": "$pickupPointId",
      "user_id": "${user_id.$}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/update-address-in-cart");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressUpdateInCartResponseFromJson(response.body);
  }

  Future<dynamic> getShippingTypeUpdateInCartResponse(
      {required int shippingId, shippingType = "home_delivery"}) async {
    var postBody = jsonEncode({
      "shipping_id": "$shippingId",
      "shipping_type": "$shippingType",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/update-shipping-type-in-cart");

    //
    //
    //
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return addressUpdateInCartResponseFromJson(response.body);
  }
}
