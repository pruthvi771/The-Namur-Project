import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
  List<Datum>? data;
  bool? success;
  int? status;

  SubCategoryModel({
    this.data,
    this.success,
    this.status,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Datum {
  int? id;
  String? name;
  String? banner;
  String? icon;
  int? numberOfChildren;
  Links? links;

  Datum({
    this.id,
    this.name,
    this.banner,
    this.icon,
    this.numberOfChildren,
    this.links,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    banner: json["banner"],
    icon: json["icon"],
    numberOfChildren: json["number_of_children"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "banner": banner,
    "icon": icon,
    "number_of_children": numberOfChildren,
    "links": links?.toJson(),
  };
}

class Links {
  String? products;
  String? subCategories;

  Links({
    this.products,
    this.subCategories,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    products: json["products"],
    subCategories: json["sub_categories"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
    "sub_categories": subCategories,
  };
}
