import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class CheckoutRequested extends CheckoutEvent {
  const CheckoutRequested();

  @override
  List<Object> get props => [];
}
