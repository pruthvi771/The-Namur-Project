class SellProduct {
  final String id;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final String priceType;
  final String category;
  final String subCategory;
  final String subSubCategory;
  final String imageURL;

  SellProduct({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.priceType,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.imageURL,
  });
}
