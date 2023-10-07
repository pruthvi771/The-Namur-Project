import 'dart:async';

import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_exceptions.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';

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

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);

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
        verificationCompleted: (_) {
          print('Phone number automatically verified and user signed in: ');
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.code);
          print(e.message);
          verificationIdCompleter.completeError('Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('OTP sent to your phone number');
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception('Invalid OTP. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else if (e.code == 'session-expired') {
        throw Exception('OTP expired. Please try again.');
      } else {
        // print(e);
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      // print(_);
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
}
