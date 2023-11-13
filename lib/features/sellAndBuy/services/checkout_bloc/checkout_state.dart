import 'package:equatable/equatable.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CartLoading extends CheckoutState {
  const CartLoading();

  @override
  List<Object> get props => [];
}

final class CartError extends CheckoutState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
