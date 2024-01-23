import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ReduceQuantityResponseEnum {
  Success,
  NotEnoughQuantity,
  ProductNotFound,
  Error,
}

class CheckoutRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map?> getCartDocumenyByUserId({required String userID}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('cart').doc(userID).get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      return data;
    } catch (e) {
      return null;
    }
  }

  Future<Map?> getProductDocumenyByProductId(
      {required String productID}) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productID)
          .get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      return data;
    } catch (e) {
      return null;
    }
  }

  Future<List> reduceProductQuantity({
    required String productId,
    required int quantityToReduce,
  }) async {
    try {
      var productRef = _firestore.collection('products').doc(productId);
      DocumentSnapshot productSnapshot = await productRef.get();

      // if (!productSnapshot.exists) {
      //   throw Exception('Product not found');
      // }

      int currentQuantity = (productSnapshot.data() as Map)['quantity'] ?? 0;
      if (currentQuantity < quantityToReduce) {
        return [ReduceQuantityResponseEnum.NotEnoughQuantity, currentQuantity];
      }

      int newQuantity = currentQuantity - quantityToReduce;

      await productRef.update({'quantity': newQuantity});

      return [ReduceQuantityResponseEnum.Success, 0];
    } catch (error) {
      return [ReduceQuantityResponseEnum.Error, 0];
    }
  }

  Future<List> canReduceProductQuantity({
    required String productId,
    required int quantityToReduce,
  }) async {
    try {
      var productRef = _firestore.collection('products').doc(productId);
      DocumentSnapshot productSnapshot = await productRef.get();

      int currentQuantity = (productSnapshot.data() as Map)['quantity'] ?? 0;
      if (currentQuantity < quantityToReduce) {
        return [false, currentQuantity];
      }

      return [true, 0];

      // int newQuantity = currentQuantity - quantityToReduce;

      // await productRef.update({'quantity': newQuantity});

      //
      // return [ReduceQuantityResponseEnum.Success, 0];
    } catch (error) {
      return [ReduceQuantityResponseEnum.Error, 0];
    }
  }

  Future<String?> createOrder(String userID, List<OrderItem> items,
      CheckoutAddress checkoutAddress) async {
    try {
      // extracting all seller IDs into a list
      List<String> sellerIDs = items.map((item) => item.sellerID).toList();
      DocumentReference<Map<String, dynamic>> orderDocRef =
          await _firestore.collection('orders').add(
        {
          'buyer': userID,
          'sellers': sellerIDs,
          'orderDate': FieldValue.serverTimestamp(),
          'totalAmount': calculateTotalAmount(items),
          'items': items.map((item) => item.toMap()).toList(),
          'status': 'Confirmed',
          'address': checkoutAddress.toMap(),
        },
      );

      return orderDocRef.id;
    } catch (e) {}
  }

  double calculateTotalAmount(List<OrderItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
