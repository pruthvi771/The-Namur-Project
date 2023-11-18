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

class CheckoutInitialEventRequested extends CheckoutEvent {
  const CheckoutInitialEventRequested();

  @override
  List<Object> get props => [];
}
