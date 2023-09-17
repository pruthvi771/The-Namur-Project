import 'package:active_ecommerce_flutter/services/auth_user.dart';

abstract class AuthProvider {
  // Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> loginWithEmail({required String email, required String password});

  Future<AuthUser> createUserWithEmail({required String email, required String password});

  Future<AuthUser> loginWithGoogle();

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<String?> phoneNumberVerification({required String phone});

  Future<AuthUser?> loginWithPhone({required String verificationId, required String otp});

  Future<void> resetPasswordForEmail({required String email});

}