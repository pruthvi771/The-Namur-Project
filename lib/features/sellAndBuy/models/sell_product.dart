class SellProduct {
  final String id;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final String quantityUnit;
  final String category;
  final String subCategory;
  final String subSubCategory;
  final List<dynamic> imageURL;
  final String sellerId;
  final bool isSecondHand;
  final String village;
  final String gramPanchayat;
  final String taluk;
  final String district;
  final DateTime createdAt;

  SellProduct({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.quantityUnit,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.imageURL,
    required this.sellerId,
    required this.isSecondHand,
    required this.village,
    required this.gramPanchayat,
    required this.taluk,
    required this.district,
    required this.createdAt,
  });
}
