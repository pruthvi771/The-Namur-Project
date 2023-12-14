import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:equatable/equatable.dart';

abstract class BuyState extends Equatable {
  const BuyState();

  @override
  List<Object> get props => [];
}

final class BuyInitial extends BuyState {}

final class BuyProductsForSubCategoryReceived extends BuyState {
  final List<SellProduct> products;

  const BuyProductsForSubCategoryReceived({
    required this.products,
  });

  @override
  List<Object> get props => [products];
}

final class BuyLoading extends BuyState {
  const BuyLoading();

  @override
  List<Object> get props => [];
}

final class BuyError extends BuyState {
  final String message;

  const BuyError({required this.message});

  @override
  List<Object> get props => [message];
}

final class RatingDataReceived extends BuyState {
  final double rating;

  const RatingDataReceived({
    required this.rating,
  });

  @override
  List<Object> get props => [
        rating,
      ];
}
