import 'package:equatable/equatable.dart';

abstract class BuyEvent extends Equatable {
  const BuyEvent();

  @override
  List<Object> get props => [];
}

class BuyProductsForSubCategoryRequested extends BuyEvent {
  final String subCategory;

  const BuyProductsForSubCategoryRequested({
    required this.subCategory,
  });

  @override
  List<Object> get props => [subCategory];
}

class RatingUpdateRequested extends BuyEvent {
  final double rating;
  final String productId;
  final int indexInOrderItems;
  final String orderId;
  final bool isFirstTime;
  final double? initialRatingInProductDoc;

  const RatingUpdateRequested({
    required this.rating,
    required this.isFirstTime,
    required this.productId,
    required this.indexInOrderItems,
    required this.orderId,
    required this.initialRatingInProductDoc,
  });

  @override
  List<Object> get props => [
        rating,
        productId,
        indexInOrderItems,
        orderId,
        isFirstTime,
      ];
}

class RatingDataRequested extends BuyEvent {
  final String orderId;
  final int indexInOrderItems;

  const RatingDataRequested({
    required this.indexInOrderItems,
    required this.orderId,
  });

  @override
  List<Object> get props => [
        indexInOrderItems,
        orderId,
      ];
}

// class SellerDataRequested extends BuyEvent {
//   final String sellerId;

//   const SellerDataRequested({
//     required this.sellerId,
//   });

//   @override
//   List<Object> get props => [sellerId];
// }
