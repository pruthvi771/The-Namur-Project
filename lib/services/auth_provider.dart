import 'package:active_ecommerce_flutter/services/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser> createUser({required String email, required String password});

  Future<void> logOut();

  Future<void> sendEmailVerification();

}