import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/data_model/common_response.dart';
import 'package:active_ecommerce_flutter/data_model/followed_sellers_response.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/shop_response.dart';
import 'package:active_ecommerce_flutter/data_model/shop_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ShopRepository {
  Future<dynamic> getShops({name = "", page = 1}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}");

    print(url.toString());

    final response = await http.get(url,
      headers: {
        "App-Language": app_language.$!,
      },);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return shopResponseFromJson(response.body);
  }

  Future<ShopDetailsResponse> getShopInfo({@required id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/details/${id}");
    print(url.toString());
    final response =
        await http.get(url,
          headers: {
            "App-Language": app_language.$!,
          },);


    return shopDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int? id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/top/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code":SystemConfig.systemCurrency!.code!,
        "Currency-Exchange-Rate":SystemConfig.systemCurrency!.exchangeRate.toString(),
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getNewFromThisSellerProducts({int? id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/new/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code":SystemConfig.systemCurrency!.code!,
        "Currency-Exchange-Rate":SystemConfig.systemCurrency!.exchangeRate.toString(),
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getfeaturedFromThisSellerProducts(
      {int? id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/featured/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code":SystemConfig.systemCurrency!.code!,
        "Currency-Exchange-Rate":SystemConfig.systemCurrency!.exchangeRate.toString(),
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<CommonResponse> followedCheck(id) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/followed-seller/check/$id");
    final response = await http
        .get(url,
      headers: {
          "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> followedAdd(id) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/followed-seller/store/$id");
    final response = await http
        .get(url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> followedRemove(id) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/followed-seller/remove/$id");
    final response = await http
        .get(url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    return commonResponseFromJson(response.body);
  }

  Future<FollowedSellersResponse> followedList({page=1}) async {
    Uri url =  Uri.parse("${AppConfig.BASE_URL}/followed-seller?page=$page");
    final response = await http
        .get(url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    print(response.body);
    return followedSellersResponseFromJson(response.body);
  }


}
