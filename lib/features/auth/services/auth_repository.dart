import 'dart:async';
import 'dart:convert';

import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/models/postoffice_response_model.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart'
    show
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        // PhoneAuthCredential,
        PhoneAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreRepository firestoreRepository = FirestoreRepository();

  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : AuthUser.fromFirebase(user);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not found. Please register first.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password. Please try again.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email. Please try again.');
      } else if (e.code == 'user-disabled') {
        throw Exception('User is disabled. Please contact support.');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> createUserWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      var userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      firestoreRepository.addUserToBuyerSellerCollections(
          userId: userCredentials.user!.uid,
          name: name,
          email: userCredentials.user!.email!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is not strong enough.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception(
            'The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Something went wrong. Please contact support.');
      } else {
        throw Exception('Something went wrong. Please try again later.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<void> logOut() async {
    // final user = _firebaseAuth.currentUser;

    // if (user != null) {
    try {
      await _firebaseAuth.signOut();
      try {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
      } catch (_) {
        // ignore
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw Exception('No internet connection');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<void> sendEmailVerification() async {
  //   final user = _firebaseAuth.currentUser;
  //   if (user != null) {
  //     await user.sendEmailVerification();
  //   } else {
  //     throw UserNotLoggedInAuthException();
  //   }
  // }

  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      var userCredential = await _firebaseAuth.signInWithCredential(credential);

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(userCredential.user!.uid)
          .get();

      bool toReturn = false;

      if (!userSnapshot.exists) {
        toReturn = true;
        await firestoreRepository.addUserToBuyerSellerCollections(
          userId: userCredential.user!.uid,
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          // photoURL: userCredential.user!.photoURL!,
          googleSignIn: true,
        );

        await firestoreRepository.createEmptyHiveDataInstance(
            userId: userCredential.user!.uid);
      } else {
        toReturn = false;
        await firestoreRepository.syncFirestoreDataWithHive(
            userId: userCredential.user!.uid);
      }
      return toReturn;

      // final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
            'This email is already in use by a different login method.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Something went wrong. Please contact support.');
      } else if (e.code == 'user-disabled') {
        throw Exception('User is disabled. Please contact support.');
      } else if (e.code == 'play-services-not-available') {
        throw Exception('Please install Google Play Store first.');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<String?> phoneNumberVerification({
    required String phone,
  }) async {
    try {
      Completer<String?> verificationIdCompleter = Completer<String?>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          verificationIdCompleter.completeError(
              'Verification failed. Please check your phone number and try again.');
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationIdCompleter.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      return verificationIdCompleter.future;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        throw Exception('Invalid phone number. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> loginWithPhone(
      {required String verificationId, required String otp}) async {
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await _firebaseAuth.signInWithCredential(credentials);
      final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();

      if (user == null) {
        throw Exception('Something went wrong. Please try again.');
      }

      firestoreRepository.syncFirestoreDataWithHive(userId: user.userId);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception('Invalid OTP. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else if (e.code == 'session-expired') {
        throw Exception('OTP expired. Please try again.');
      } else {
        //
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      //
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> signupWithPhone({
    required String verificationId,
    required String phoneNumber,
    required String otp,
    required String username,
    required String email,
  }) async {
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      var userCredential =
          await _firebaseAuth.signInWithCredential(credentials);
      final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();

      if (user == null) {
        throw Exception('Something went wrong. Please try again.');
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(userCredential.user!.uid)
          .get();

      if (!userSnapshot.exists) {
        firestoreRepository.addUserToBuyerSellerCollections(
          userId: userCredential.user!.uid,
          name: username,
          email: email,
          phoneNumber: phoneNumber,
        );

        firestoreRepository.createEmptyHiveDataInstance(
          userId: userCredential.user!.uid,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception('Invalid OTP. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else if (e.code == 'session-expired') {
        throw Exception('OTP expired. Please try again.');
      } else {
        //
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      //
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> resetPasswordForEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('Invalid email');
      } else if (e.code == 'user-not-found') {
        throw Exception('User not found. Please register first.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
      // throw GenericAuthException();
    }
  }

  Future<PostOfficeResponse?> getLocationsForPincode(
      {required String pinCode}) async {
    try {
      var postOfficeResponse = await http
          .get(Uri.parse('https://api.postalpincode.in/pincode/$pinCode'));

      // if (postOfficeResponse.statusCode == 200) {
      var jsonResponse = json.decode(postOfficeResponse.body);

      //
      if (jsonResponse[0]['Status'] == 'Success') {
        // return PostOfficeResponse.fromJson(jsonResponse);
        return PostOfficeResponse.fromJson(jsonResponse[0]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<PostOfficeResponse?> getLocationsForPincodeFromRapidAPI(
      {required String pinCode}) async {
    try {
      var postOfficeResponse = await http.post(
        Uri.parse('https://pincode.p.rapidapi.com/'),
        headers: <String, String>{
          'content-type': 'application/json',
          'Content-Type': 'application/json',
          'X-RapidAPI-Key':
              'eaa65359f4mshafc281c7573fbe7p1d83eajsncdf2af96ce07',
          'X-RapidAPI-Host': 'pincode.p.rapidapi.com'
        },
        body: jsonEncode(<String, String>{
          'searchBy': 'pincode',
          'value': pinCode,
        }),
      );

      if (postOfficeResponse.statusCode == 200) {
        var jsonResponse = json.decode(postOfficeResponse.body);

        List<PostOffice> postOffices = [];

        for (Map postOffice in jsonResponse) {
          postOffices.add(
            PostOffice(
                name: postOffice['office'],
                circle: postOffice['circle'],
                district: postOffice['district'],
                division: postOffice['division'],
                region: postOffice['region']),
          );
        }

        return PostOfficeResponse(
          message: 'Postal Pincode Offices Service from RapidAPI',
          status: 'Success',
          postOffices: postOffices,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
