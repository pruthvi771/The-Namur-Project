import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/common_response.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/login_response.dart';
import 'package:active_ecommerce_flutter/data_model/logout_response.dart';
import 'package:active_ecommerce_flutter/data_model/signup_response.dart';
import 'package:active_ecommerce_flutter/data_model/resend_code_response.dart';
import 'package:active_ecommerce_flutter/data_model/confirm_code_response.dart';
import 'package:active_ecommerce_flutter/data_model/password_forget_response.dart';
import 'package:active_ecommerce_flutter/data_model/password_confirm_response.dart';
import 'package:active_ecommerce_flutter/data_model/user_by_token.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(String? email, String password) async {
    var postBody = jsonEncode({
      "email": "$email",
      "password": "$password",
      "identity_matrix": AppConfig.purchase_code
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);

    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(
    String socialProvider,
    String? name,
    String? email,
    String? provider, {
    accessToken = "",
    secretToken = "",
  }) async {
    email = email == ("null") ? "" : email;

    var postBody = jsonEncode({
      "name": name,
      "email": email,
      "provider": "$provider",
      "social_provider": "$socialProvider",
      "access_token": "$accessToken",
      "secret_token": "$secretToken"
    });

    // //
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/social-login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);
    // // //
    // //
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );

    //

    return logoutResponseFromJson(response.body);
  }

  Future<CommonResponse> getAccountDeleteResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/account-deletion");

    //

    //
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    //
    return commonResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
    String name,
    String? emailOrPhone,
    String password,
    String passwordConfirmation,
    String registerBy,
    String capchaKey,
  ) async {
    var postBody = jsonEncode({
      "name": "$name",
      "email_or_phone": "$emailOrPhone",
      "password": "$password",
      "password_confirmation": "$passwordConfirmation",
      "register_by": "$registerBy",
      "g-recaptcha-response": "$capchaKey",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/signup");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);
    //

    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      int? userId, String verifyBy) async {
    var postBody =
        jsonEncode({"user_id": "$userId", "register_by": "$verifyBy"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);

    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      int? userId, String verificationCode) async {
    var postBody = jsonEncode(
        {"user_id": "$userId", "verification_code": "$verificationCode"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      String? emailOrPhone, String sendCodeBy) async {
    var postBody = jsonEncode(
        {"email_or_phone": "$emailOrPhone", "send_code_by": "$sendCodeBy"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/forget_request",
    );

    //
    //

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);

    ////

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      String verificationCode, String password) async {
    var postBody = jsonEncode(
        {"verification_code": "$verificationCode", "password": "$password"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/confirm_reset",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      String? emailOrCode, String verifyBy) async {
    var postBody =
        jsonEncode({"email_or_code": "$emailOrCode", "verify_by": "$verifyBy"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var postBody = jsonEncode({"access_token": "${access_token.$}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token");
    if (access_token.$!.isNotEmpty) {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: postBody);

      return userByTokenResponseFromJson(response.body);
    }
    return UserByTokenResponse();
  }
}
