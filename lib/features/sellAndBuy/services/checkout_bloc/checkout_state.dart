import 'package:equatable/equatable.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();

  @override
  List<Object> get props => [];
}

final class CheckoutCompleted extends CheckoutState {
  final String orderId;
  const CheckoutCompleted({
    required this.orderId,
  });

  @override
  List<Object> get props => [orderId];
}

final class NotEnoughQuantityError extends CheckoutState {
  final String productName;
  final int availableQuantity;
  const NotEnoughQuantityError({
    required this.productName,
    required this.availableQuantity,
  });

  @override
  List<Object> get props => [productName, availableQuantity];
}

final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object> get props => [message];
}
