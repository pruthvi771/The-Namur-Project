import 'dart:io';
import 'dart:typed_data';

import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SellRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> addProductBuying({
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    // required String priceType,
    required String category,
    required String subCategory,
    required String subSubCategory,
    required List imageURL,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');

      // Add a new document with a generated ID
      DocumentReference documentReference = await products.add({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        // 'priceType': priceType,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'imageURL': imageURL,
        'sellerId': userId,
      });
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
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subCategory', isEqualTo: subCategory)
        .where('sellerId', isEqualTo: _firebaseAuth.currentUser!.uid)
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
      );
    }).toList();
    print(products.length);

    return products;
  }

  Future<void> deleteProduct({
    required String productId,
  }) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<List<String>?> uploadImagesToFirebaseStorage({
    required List<XFile> imageFiles,
    required String docId,
  }) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      List<String> downloadURLs = [];

      int fileNameIndex = 0;

      for (var imageFile in imageFiles) {
        File file = File(imageFile.path);
        String fileName = fileNameIndex.toString();
        fileNameIndex++;

        // Reference to the image file in Firebase Storage
        Reference ref = storage.ref().child('products/$docId/$fileName');

        // Upload file to Firebase Storage
        await ref.putFile(file);

        // Get the download URL of the uploaded file
        String downloadURL = await ref.getDownloadURL();
        downloadURLs.add(downloadURL);
      }

      return downloadURLs;
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  Future<void> saveProductImages({
    required List<XFile> imageList,
    required String docId,
  }) async {
    try {
      var imageURL = await uploadImagesToFirebaseStorage(
          docId: docId, imageFiles: imageList);
      await _firestore.collection('products').doc(docId).update({
        'imageURL': imageURL,
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<String?> addMachineBuying({
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    // required String priceType,
    required String category,
    required String subCategory,
    required String subSubCategory,
    required List imageURL,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference products =
          FirebaseFirestore.instance.collection('machines');

      // Add a new document with a generated ID
      DocumentReference documentReference = await products.add({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        // 'priceType': priceType,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'imageURL': imageURL,
        'sellerId': userId,
      });
      return documentReference.id;
    } catch (e) {
      print('Error adding document: $e');
      return null; // Return null in case of error
    }
  }
}
