import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productID;
  final String name;
  final double price;
  final int quantity;
  final String sellerID;
  final double? rating;

  OrderItem({
    required this.productID,
    required this.name,
    required this.price,
    required this.quantity,
    required this.sellerID,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'name': name,
      'price': price,
      'quantity': quantity,
      'sellerID': sellerID,
      'rating': rating,
    };
  }
}

class OrderListItem {
  final String orderID;
  final double totalAmount;
  final String status;
  final Timestamp timestamp; // Optional

  OrderListItem({
    required this.orderID,
    required this.totalAmount,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderID': orderID,
      'totalAmount': totalAmount,
      'status': status,
      'timestamp': timestamp,
    };
  }
}

class OrderDocument {
  final String buyerID;
  final Timestamp timestamp;
  final double totalAmount;
  final String status;
  final List sellers;
  final bool rent;
  final String? bookedDate;
  final String? bookedSlot;
  final List<OrderItem> orderItems;

  OrderDocument({
    required this.buyerID,
    required this.timestamp,
    required this.totalAmount,
    required this.status,
    required this.sellers,
    required this.orderItems,
    required this.rent,
    this.bookedDate,
    this.bookedSlot,
  });
  Map<String, dynamic> toMap() {
    return {
      'buyerID': buyerID,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
      'status': status,
      'sellers': sellers,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
      'rent': rent,
      'bookedDate': bookedDate,
      'bookedSlot': bookedSlot,
    };
  }
}
