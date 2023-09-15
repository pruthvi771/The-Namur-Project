import 'package:active_ecommerce_flutter/services/auth_user.dart';

abstract class AuthProvider {
  // Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> loginWithEmail({required String email, required String password});

  Future<AuthUser> createUserWithEmail({required String email, required String password});

  Future<void> logOut();

  Future<void> sendEmailVerification();

}