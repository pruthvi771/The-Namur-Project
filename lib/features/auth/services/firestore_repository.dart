import 'dart:async';

import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FirestoreRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserToBuyerSellerCollections({
    required String userId,
    required String name,
    required String email,
    String? photoURL,
  }) async {
    try {
      _firestore.collection('buyer').doc(userId).set({
        'name': name,
        'email': email,
        'address': '',
        'phone number': '',
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
}
