import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SellRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  // Future<void> loginWithEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       throw Exception('User not found. Please register first.');
  //     } else {
  //       throw Exception('Something went wrong. Please try again.');
  //     }
  //   } catch (_) {
  //     throw Exception('Something went wrong. Please try again.');
  //   }
  // }

  Future<String?> addProductBuying({
    required String productName,
    required String productDescription,
    required double productPrice,
    required String priceType,
    required String category,
    required String subCategory,
    required String subSubCategory,
    required String imageURL,
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
        'priceType': priceType,
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

  Future<String> uploadImagetoFirebase(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> saveProductImage({
    required Uint8List file,
    required String docId,
  }) async {
    try {
      var imageURL = await uploadImagetoFirebase('products/$docId', file);
      await _firestore.collection('products').doc(docId).update({
        'imageURL': imageURL,
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }
}