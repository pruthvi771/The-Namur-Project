import 'package:active_ecommerce_flutter/features/sellAndBuy/models/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
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

  Future<CartProduct?> isAlreadyInCart({
    required String productId,
  }) async {
    var currentUser = _firebaseAuth.currentUser!;

    DocumentSnapshot<Map<String, dynamic>> cartSnapshot =
        await _firestore.collection('cart').doc(currentUser.uid).get();

    if (cartSnapshot.exists) {
      List<dynamic> products = cartSnapshot.data()!['products'];

      for (var product in products) {
        if (product['productId'] == productId) {
          return CartProduct(
              productId: productId, quantity: product['quantity']);
        }
      }
    }

    return null;
  }

  Future<CartProduct?> updateCartQuantity({
    required String productId,
    required int currentQuantity,
    required UpdateCartQuantityType type,
  }) async {
    var currentUser = _firebaseAuth.currentUser!;
    CollectionReference cartCollection = _firestore.collection('cart');
    var userCartRef = cartCollection.doc(currentUser.uid);
    DocumentSnapshot cartSnapshot = await userCartRef.get();

    if (cartSnapshot.exists) {
      List<dynamic> products = cartSnapshot['products'];

      int productIndex =
          products.indexWhere((product) => product['productId'] == productId);

      int newQuantity = type == UpdateCartQuantityType.increment
          ? currentQuantity + 1
          : currentQuantity - 1;

      if (productIndex != -1) {
        Map<String, dynamic> updatedProduct = Map.from(products[productIndex]);
        updatedProduct['quantity'] = newQuantity;

        products[productIndex] = updatedProduct;

        await userCartRef.update({'products': products});
        return CartProduct(productId: productId, quantity: newQuantity);
      } else {}
    } else {}

    return null;
  }

  Future<void> removeFromCart({
    required String productId,
  }) async {
    var currentUser = _firebaseAuth.currentUser!;

    CollectionReference cartCollection = _firestore.collection('cart');

    DocumentSnapshot cartSnapshot =
        await cartCollection.doc(currentUser.uid).get();

    if (cartSnapshot.exists) {
      List<dynamic> products = List.from(cartSnapshot['products']);

      int productIndex =
          products.indexWhere((product) => product['productId'] == productId);

      if (productIndex != -1) {
        products.removeAt(productIndex);

        await cartCollection
            .doc(currentUser.uid)
            .update({'products': products});
      } else {}
    } else {}
  }

  Future<void> clearCart() async {
    var currentUser = _firebaseAuth.currentUser!;

    CollectionReference cartCollection = _firestore.collection('cart');

    DocumentSnapshot cartSnapshot =
        await cartCollection.doc(currentUser.uid).get();

    if (cartSnapshot.exists) {
      await cartCollection.doc(currentUser.uid).delete();
    } else {}
  }
}

enum UpdateCartQuantityType { increment, decrement }
