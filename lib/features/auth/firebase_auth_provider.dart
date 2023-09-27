import 'dart:async';

import 'package:active_ecommerce_flutter/features/auth/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/auth_provider.dart';
import 'package:active_ecommerce_flutter/features/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        // PhoneAuthCredential,
        PhoneAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider implements AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : AuthUser.fromFirebase(user);
  }

  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = currentUser;
      return user != null ? user : throw UserNotFoundAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<AuthUser> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = currentUser;
      return user != null ? user : throw UserNotFoundAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'operation-not-allowed') {
        throw OperationNotAllowedAuthException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<void> logOut() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      await _firebaseAuth.signOut();
      try {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
      } catch (_) {
        // ignore
      }
    } else {
      throw UserNotLoggedInAuthException();
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

  Future<AuthUser> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);

      final user = currentUser;
      return user != null ? user : throw UserNotFoundAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AccountExistsWithDifferentCredentialAuthException();
        // } else if (e.code == 'invalid-credential') {
        //   throw InvalidCredentialAuthException();
      } else if (e.code == 'operation-not-allowed') {
        throw OperationNotAllowedAuthException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<String?> phoneNumberVerification({
    required String phone,
  }) async {
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
  }

  Future<AuthUser?> loginWithPhone(
      {required String verificationId, required String otp}) async {
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await _firebaseAuth.signInWithCredential(credentials);
      final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();

      if (user != null) {
        print('User logged in successfully');
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw InvalidOTPAuthException();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else if (e.code == 'session-expired') {
        throw ExpiredOTPAuthException();
      } else {
        print(e);
        throw GenericAuthException();
      }
    } catch (_) {
      print(_);
      throw GenericAuthException();
    }
  }

  Future<void> resetPasswordForEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
