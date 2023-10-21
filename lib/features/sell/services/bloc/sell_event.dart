part of 'sell_bloc.dart';

sealed class SellEvent extends Equatable {
  const SellEvent();

  @override
  List<Object> get props => [];
}

class SellAddProductEvent extends SellEvent {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String priceType;
  final String category;
  final String subCategory;
  final String subSubCategory;
  final Uint8List image;

  const SellAddProductEvent({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.priceType,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.image,
  });

  @override
  List<Object> get props => [
        productName,
        productDescription,
        productPrice,
        priceType,
        category,
        subCategory,
        subSubCategory,
        image,
      ];
}
