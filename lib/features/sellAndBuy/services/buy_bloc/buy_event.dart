import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class BuyEvent extends Equatable {
  const BuyEvent();

  @override
  List<Object> get props => [];
}

class BuyProductsForSubCategoryRequested extends BuyEvent {
  final String subSubCategory;

  const BuyProductsForSubCategoryRequested({
    required this.subSubCategory,
  });

  @override
  List<Object> get props => [subSubCategory];
}

// class SellerDataRequested extends BuyEvent {
//   final String sellerId;

//   const SellerDataRequested({
//     required this.sellerId,
//   });

//   @override
//   List<Object> get props => [sellerId];
// }
