

// class BusinessSettingRepository{
//   Future<List<BusinessSettingListResponse>> getBusinessSettingList()async{
//     Uri url = Uri.parse("${AppConfig.BASE_URL}/business-settings");

//    var businessSettings = [
//       "facebook_login",
//       "google_login",
//       "twitter_login",
//       "pickup_point",
//      "wallet_system",
//      "email_verification",
//      "conversation_system",
//      "shipping_type",
//      "classified_product",
//      "google_recaptcha",
//      "vendor_system_activation"
//     ];
//   String params= businessSettings.join(',');
//     var body = {
//       //'keys':params
//       "keys":params
//     };
//     //
//     var response = await http.post(url,body: body);

//     

//     return businessSettingListResponseFromJson(response.body);
//   }
// }