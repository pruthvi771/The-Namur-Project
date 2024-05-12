import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/cart_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_count_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_process_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_summary_response.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:http/http.dart' as http;

class CartRepository {
  Future<dynamic> getCartResponseList(
    int? userId,
  ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
        "Currency-Code": SystemConfig.systemCurrency!.code!,
        "Currency-Exchange-Rate":
            SystemConfig.systemCurrency!.exchangeRate.toString(),
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return cartResponseFromJson(response.body);
  }

  Future<dynamic> getCartCount() async {
    if (is_logged_in.$) {
      Uri url = Uri.parse("${AppConfig.BASE_URL}/cart-count");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
      );
      bool checkResult = ResponseCheck.apply(response.body);

      if (!checkResult) return responseCheckModelFromJson(response.body);

      return cartCountResponseFromJson(response.body);
    } else {
      return CartCountResponse(count: 0, status: false);
    }
  }

  Future<dynamic> getCartDeleteResponse(
    int? cartId,
  ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/$cartId");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return cartDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCartProcessResponse(
      String cartIds, String cartQuantities) async {
    var postBody = jsonEncode(
        {"cart_ids": "$cartIds", "cart_quantities": "$cartQuantities"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/process");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    //Provider.of<CartCounter>(OneContext().context!, listen: false).getCount();
    return cartProcessResponseFromJson(response.body);
  }

  Future<dynamic> getCartAddResponse(
      int? id, String? variant, int? userId, int? quantity) async {
    var postBody = jsonEncode({
      "id": "$id",
      "variant": variant,
      "user_id": "$userId",
      "quantity": "$quantity",
      "cost_matrix": AppConfig.purchase_code
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/add");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);
    //Provider.of<CartCounter>(OneContext().context!, listen: false).getCount();
    return cartAddResponseFromJson(response.body);
  }

  Future<dynamic> getCartSummaryResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/cart-summary");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
        "Currency-Code": SystemConfig.systemCurrency!.code!,
        "Currency-Exchange-Rate":
            SystemConfig.systemCurrency!.exchangeRate.toString(),
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return cartSummaryResponseFromJson(response.body);
  }
}
