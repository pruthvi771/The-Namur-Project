import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addRentOrderDocument({
    required String buyerId,
    required String sellerId,
    required String bookedSlot,
    required List<OrderItem> orderItems,
    required int numberOfHalfHours,
    required String bookedDate,
    required String locationName,
  }) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference products = _firestore.collection('orders');

      // Add a new document with a generated ID
      DocumentReference documentReference = await products.add(
        {
          'buyer': buyerId,
          'rent': true,
          'productID': orderItems[0].productID,
          'locationName': locationName,
          'sellers': [sellerId],
          'orderDate': FieldValue.serverTimestamp(),
          'totalAmount': (orderItems[0].price * numberOfHalfHours) / 2,
          'items': orderItems.map((item) => item.toMap()).toList(),
          'bookedSlot': bookedSlot,
          'bookedDate': bookedDate,
          'status': 'Confirmed',
        },
      );
      return documentReference.id;
    } catch (e) {
      print('Error adding document: $e');
      return null; // Return null in case of error
    }
  }
}
