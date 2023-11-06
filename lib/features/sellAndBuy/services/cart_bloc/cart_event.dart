import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartRequested extends CartEvent {
  final String productId;

  const AddToCartRequested({
    required this.productId,
  });

  @override
  List<Object> get props => [productId];
}

class CheckIfAlreadyInCartRequested extends CartEvent {
  final String productId;

  const CheckIfAlreadyInCartRequested({
    required this.productId,
  });

  @override
  List<Object> get props => [productId];
}

class UpdateCartQuantityRequested extends CartEvent {
  final String productId;
  final int currentQuantity;
  final UpdateCartQuantityType type;

  const UpdateCartQuantityRequested({
    required this.productId,
    required this.currentQuantity,
    required this.type,
  });

  @override
  List<Object> get props => [productId, currentQuantity];
}
