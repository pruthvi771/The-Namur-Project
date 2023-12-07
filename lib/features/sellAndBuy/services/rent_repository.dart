import 'dart:io';

import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RentRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<String?> addProductBuying({
  //   required String productName,
  //   required String productDescription,
  //   required double productPrice,
  //   required int productQuantity,
  //   required String quantityUnit,
  //   // required String priceType,
  //   required String category,
  //   required String subCategory,
  //   required String subSubCategory,
  //   required List imageURL,
  //   required String userId,
  //   required bool isSecondHand,
  // }) async {
  //   try {
  //     // Get a reference to the Firestore collection
  //     CollectionReference products = _firestore.collection('products');

  //     // Add a new document with a generated ID
  //     DocumentReference documentReference = await products.add({
  //       'name': productName,
  //       'description': productDescription,
  //       'price': productPrice,
  //       'quantity': productQuantity,
  //       'quantityUnit': quantityUnit,
  //       // 'priceType': priceType,
  //       'category': category,
  //       'subCategory': subCategory,
  //       'subSubCategory': subSubCategory,
  //       'imageURL': imageURL,
  //       'sellerId': userId,
  //       'isSecondHand': isSecondHand,
  //     });
  //     return documentReference.id;
  //   } catch (e) {
  //     print('Error adding document: $e');
  //     return null; // Return null in case of error
  //   }
  // }

  Future<String?> addRentOrderDocument({
    required String buyerId,
    required String sellerId,
    required String bookedSlot,
    required List bookedSlotBroken,
    required List<OrderItem> orderItems,
    required int numberOfHalfHours,
  }) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference products = _firestore.collection('orders');

      // Add a new document with a generated ID
      DocumentReference documentReference = await products.add(
        {
          'buyer': buyerId,
          'rent': true,
          'sellers': [sellerId],
          'orderDate': FieldValue.serverTimestamp(),
          'totalAmount': orderItems[0].price * numberOfHalfHours,
          'items': orderItems.map((item) => item.toMap()).toList(),
          'bookedSlot': bookedSlot,
          'bookedSlotBroken': bookedSlotBroken,
          'status': 'Confirmed',
        },
      );
      return documentReference.id;
    } catch (e) {
      print('Error adding document: $e');
      return null; // Return null in case of error
    }
  }

  Future<String?> editProductBuying({
    required String productId,
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    required String category,
    required String subCategory,
    required String subSubCategory,
    // required String imageURL,
    // required String userId,
  }) async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    try {
      await products.doc(productId).update({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        // 'imageURL': imageURL,
      });
    } catch (e) {
      print('Error updating product: $e');
      // Handle the error according to your application's requirements
    }
  }

  Future<List<SellProduct>> getProducts({
    required String subCategory,
    required bool isSecondHand,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subCategory', isEqualTo: subCategory)
        .where('sellerId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('isSecondHand', isEqualTo: isSecondHand)
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
}
