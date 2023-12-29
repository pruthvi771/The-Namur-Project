import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_details_screen.dart';
import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class CheckoutRequested extends CheckoutEvent {
  final String userID;
  const CheckoutRequested({required this.userID});

  @override
  List<Object> get props => [userID];
}

class CreateOrderRequested extends CheckoutEvent {
  final String userID;
  final CheckoutAddress address;
  const CreateOrderRequested({
    required this.userID,
    required this.address,
  });

  @override
  List<Object> get props => [userID];
}

class CheckoutInitialEventRequested extends CheckoutEvent {
  const CheckoutInitialEventRequested();

  @override
  List<Object> get props => [];
}
