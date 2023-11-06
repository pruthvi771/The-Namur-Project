import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class AddToCartSuccessful extends CartState {
  final int quantity;

  const AddToCartSuccessful({required this.quantity});

  @override
  List<Object> get props => [];
}

final class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object> get props => [];
}

final class CartQuantityLoading extends CartState {
  const CartQuantityLoading();

  @override
  List<Object> get props => [];
}

final class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
