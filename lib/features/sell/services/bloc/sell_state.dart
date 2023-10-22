import 'package:active_ecommerce_flutter/features/sell/models/sell_product.dart';
import 'package:equatable/equatable.dart';

abstract class SellState extends Equatable {
  const SellState();

  @override
  List<Object> get props => [];
}

final class SellInitial extends SellState {}

final class ProductsForSubCategoryReceived extends SellState {
  final List<SellProduct> products;

  const ProductsForSubCategoryReceived({
    required this.products,
  });

  @override
  List<Object> get props => [products];
}

final class ProductLoading extends SellState {
  const ProductLoading();

  @override
  List<Object> get props => [];
}

final class ProductAddEditDeleteSuccessfully extends SellState {
  const ProductAddEditDeleteSuccessfully();

  @override
  List<Object> get props => [];
}
