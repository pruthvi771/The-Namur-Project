import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/data_model/conversation_create_response.dart';
import 'package:active_ecommerce_flutter/data_model/conversation_response.dart';
import 'package:active_ecommerce_flutter/data_model/message_response.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ChatRepository {
  Future<dynamic> getConversationResponse({page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/chat/conversations?page=$page");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return conversationResponseFromJson(response.body);
  }

  Future<dynamic> getMessageResponse(
      {required conversationId, page = 1}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/chat/messages/$conversationId?page=$page");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return messageResponseFromJson(response.body);
  }

  Future<dynamic> getInserMessageResponse(
      {required conversationId, required String message}) async {
    var postBody = jsonEncode({
      "user_id": "${user_id.$}",
      "conversation_id": "$conversationId",
      "message": "$message"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/chat/insert-message");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return messageResponseFromJson(response.body);
  }

  Future<dynamic> getNewMessageResponse(
      {required conversationId, required lastMessageId}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/chat/get-new-messages/$conversationId/$lastMessageId");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return messageResponseFromJson(response.body);
  }

  Future<dynamic> getCreateConversationResponse(
      {required productId,
      required String title,
      required String message}) async {
    var postBody = jsonEncode({
      "user_id": "${user_id.$}",
      "product_id": "$productId",
      "title": "$title",
      "message": "$message"
    });

    //

    Uri url = Uri.parse("${AppConfig.BASE_URL}/chat/create-conversation");
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

    //
    return conversationCreateResponseFromJson(response.body);
  }
}
