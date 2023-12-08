import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:equatable/equatable.dart';

abstract class RentEvent extends Equatable {
  const RentEvent();

  @override
  List<Object> get props => [];
}

class RentProductRequested extends RentEvent {
  // final String buyerId;
  final String sellerId;
  final String bookedSlot;
  // final List bookedSlotBroken;
  final List<OrderItem> orderItems;
  final int numberOfHalfHours;
  final String locationName;
  final String bookedDate;

  const RentProductRequested(
      {
      // required this.buyerId,
      required this.sellerId,
      required this.bookedSlot,
      // required this.bookedSlotBroken,
      required this.orderItems,
      required this.numberOfHalfHours,
      required this.locationName,
      required this.bookedDate});

  @override
  List<Object> get props => [
        // buyerId,
        sellerId,
        bookedSlot,
        // bookedSlotBroken,
        orderItems,
        numberOfHalfHours,
        locationName,
        bookedDate
      ];
}
