import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/sub_category/sub_category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
        //
        //
      } else {
        // throw Exception("error in sub category controller");
      }
    } catch (e) {}
  }

  @override
  void onInit() {
    GetSubCategory(0);

    super.onInit();
  }
}
