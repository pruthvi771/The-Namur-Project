import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    var currentUser = _firebaseAuth.currentUser!;

    CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('cart');

    DocumentSnapshot cartDoc = await cartCollection.doc(currentUser.uid).get();

    if (cartDoc.exists) {
      await cartCollection.doc(currentUser.uid).update({
        'products': FieldValue.arrayUnion([
          {
            'productId': productId,
            'quantity': quantity,
          }
        ]),
      });
    } else {
      await cartCollection.doc(currentUser.uid).set({
        'products': [
          {
            'productId': productId,
            'quantity': quantity,
          }
        ],
      });
    }
  }

  Future<void> addUserToBuyerSellerCollections({
    required String userId,
    required String name,
    required String email,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      // Use the add method to add a document with an auto-generated ID
      await _firestore.collection('orders').add({
        'field1': 'value1',
        'field2': 'value2',
        // Add other fields as needed
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> createOrder(String userID, List<OrderItem> items) async {
    try {
      DocumentReference<Map<String, dynamic>> orderDocRef =
          await _firestore.collection('orders').add(
        {
          'userID': userID,
          'orderDate': FieldValue.serverTimestamp(),
          'totalAmount': calculateTotalAmount(items),
          'items': items.map((item) => item.toMap()).toList(),
        },
      );

      print('Order created successfully! Order ID: ${orderDocRef.id}');
    } catch (e) {
      print('Error creating order: $e');
    }
  }

  double calculateTotalAmount(List<OrderItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}

class OrderItem {
  final String productID;
  final double price;
  final int quantity;
  final String? sellerID; // Optional

  OrderItem({
    required this.productID,
    required this.price,
    required this.quantity,
    this.sellerID,
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
