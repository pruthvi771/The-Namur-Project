import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/sub_category/sub_category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../app_config.dart';
import '../helpers/shared_value_helper.dart';

class SubCategoryController extends GetxController {
  var subcategoryList = SubCategoryModel().obs;
  late int id;
  Future GetSubCategory(id) async {
    final uri =
        Uri.parse("https://ecom.raylancer.co/api/v2/sub-categories/$id");
    try {
      http.Response response = await http.get(Uri.parse("$uri"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        subcategoryList.value = SubCategoryModel.fromJson(data);
        print("${subcategoryList.value.data?.length}");
        print("${response.body}");
      } else {
        throw Exception("error in sub category controller");
      }
    } catch (e) {
      print("error in sub category controller (not my file)");
    }
  }

  @override
  void onInit() {
    GetSubCategory(0);
    // TODO: implement onInit
    super.onInit();
  }
}
