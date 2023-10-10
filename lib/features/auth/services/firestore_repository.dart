import 'dart:async';
import 'dart:typed_data';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addUserToBuyerSellerCollections({
    required String userId,
    required String name,
    required String email,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      _firestore.collection('buyer').doc(userId).set({
        'name': name,
        'email': email,
        'address': '',
        'phone number': phoneNumber ?? '',
        'location_id': '',
        'photoURL': photoURL ?? '',
        // add other fields as needed
      });

      _firestore.collection('seller').doc(userId).set({
        'name': name,
        'email': email,
        'address': '',
        'phone number': '',
        'location_id': '',
        'Products_Buy': '',
        'adhaar_id': '',
        'adhaar_id_verified': false,
        'GST': '',
        'GST_verified': false,
        'PAN': '',
        'PAN_verified': false,
        'profile_complete': false,
        'photoURL': photoURL ?? '',
        // add other fields as needed
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<BuyerData> getBuyerData({
    required String userId,
  }) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(userId)
          .get();
      return BuyerData.fromJson(userSnapshot.data() as Map<String, dynamic>);
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<String> uploadImagetoFirebase(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> saveProfileImage({
    required Uint8List file,
  }) async {
    var user = FirebaseAuth.instance.currentUser!;
    try {
      var photoURL =
          await uploadImagetoFirebase('${user.uid}/profileImage', file);
      await _firestore.collection('buyer').doc(user.uid).update({
        'photoURL': photoURL,
      });
      await _firestore.collection('seller').doc(user.uid).update({
        'photoURL': photoURL,
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<List<String>> getAllRegisteredPhoneNumbers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('buyer').get();

      List<String> phoneNumbers = querySnapshot.docs
          .map((doc) => doc.get('phone number') as String)
          .toList();

      return phoneNumbers;
    } catch (e) {
      // Handle errors here
      throw Exception(
          'Something went wrong. Please try again later or contact support.');
      // return [];
    }
  }
}
