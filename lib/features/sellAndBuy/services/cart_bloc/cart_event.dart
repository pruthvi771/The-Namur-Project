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
