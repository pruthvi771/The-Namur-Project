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
  const CheckoutCompleted();

  @override
  List<Object> get props => [];
}

final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object> get props => [message];
}
