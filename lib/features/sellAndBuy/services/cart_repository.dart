import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/cart_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CartRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<SellProduct>> getProductsForSubSubCategory({
    required String subSubCategory,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subSubCategory', isEqualTo: subSubCategory)
        .get();

    var products = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      print(doc.id);
      return SellProduct(
        id: doc.id,
        productName: data['name'],
        productDescription: data['description'],
        productPrice: data['price'],
        productQuantity: data['quantity'],
        quantityUnit: data['quantityUnit'],
        // priceType: data['priceType'],
        category: data['category'],
        subCategory: data['subCategory'],
        subSubCategory: data['subSubCategory'],
        imageURL: data['imageURL'],
        sellerId: data['sellerId'],
        isSecondHand: data['isSecondHand'],
      );
    }).toList();
    print(products.length);

    return products;
  }

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

    // CollectionReference cartCollection = _firestore.collection('cart');

    // DocumentSnapshot cartDoc = await cartCollection.doc(currentUser.uid).get();

    // print(cartDoc.data());

    // if (cartDoc.exists) {
    //   int productIndex = cartDoc['products']
    //       .indexWhere((product) => product['productId'] == productId);

    //   int newQuantity = type == UpdateCartQuantityType.increment
    //       ? currentQuantity + 1
    //       : currentQuantity - 1;

    //   if (productIndex != -1) {
    //     print(
    //         'old cart product ${cartDoc['products'][productIndex]['quantity']}');
    //     cartDoc['products'][productIndex]['quantity'] = newQuantity;
    //     print(
    //         'new cart product ${cartDoc['products'][productIndex]['quantity']}');
    //     print(cartDoc['products']);

    //     // Update the 'products' field in the cart document
    //     await cartCollection.doc(currentUser.uid).update({
    //       'products': cartDoc['products'],
    //     });
    //     return CartProduct(productId: productId, quantity: newQuantity);

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
        // Create a copy of the product object to update
        Map<String, dynamic> updatedProduct = Map.from(products[productIndex]);
        updatedProduct['quantity'] = newQuantity;

        if (newQuantity == 0) {
          removeFromCart(productId: productId);
        }

        // Update the 'products' array with the updated product
        products[productIndex] = updatedProduct;

        // Update the 'products' field in the cart document
        await userCartRef.update({'products': products});
        return CartProduct(productId: productId, quantity: newQuantity);
      } else {
        print('Product with productId $productId not found in the cart.');
      }
    } else {
      print('User\'s cart document does not exist.');
    }

    return null;
  }

  Future<CartProduct?> removeFromCart({
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
}

enum UpdateCartQuantityType { increment, decrement }
