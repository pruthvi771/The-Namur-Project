import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productID;
  final double price;
  final int quantity;
  final String sellerID; // Optional

  OrderItem({
    required this.productID,
    required this.price,
    required this.quantity,
    required this.sellerID,
  });

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'price': price,
      'quantity': quantity,
      'sellerID': sellerID,
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
  final List<OrderItem> orderItems;

  OrderDocument({
    required this.buyerID,
    required this.timestamp,
    required this.totalAmount,
    required this.status,
    required this.sellers,
    required this.orderItems,
  });
  Map<String, dynamic> toMap() {
    return {
      'buyerID': buyerID,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
      'status': status,
      'sellers': sellers,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
    };
  }
}
