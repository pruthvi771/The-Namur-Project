import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:active_ecommerce_flutter/data_model/auction_product_bid_place_response.dart';

import '../app_config.dart';
import '../data_model/auction_product_details_response.dart';
import '../data_model/product_mini_response.dart';
import '../helpers/shared_value_helper.dart';

class AuctionProductsRepository {
  Future<ProductMiniResponse> getAuctionProducts({page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auction/products?page=$page");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<AuctionProductDetailsResponse> getAuctionProductsDetails(
      {int? id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auction/products/$id");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return auctionProductDetailsResponseFromJson(response.body);
  }

  Future<AuctionProductPlaceBidResponse> placeBidResponse(
      String productId, String amount) async {
    //
    //

    var postBody = jsonEncode({
      "product_id": "$productId",
      "amount": "$amount",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auction/place-bid");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}"
        },
        body: postBody);

    return auctionProductPlaceBidResponseFromJson(response.body);
  }
}
