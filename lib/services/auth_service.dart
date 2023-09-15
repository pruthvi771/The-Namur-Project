import 'package:active_ecommerce_flutter/services/auth_user.dart';
import 'package:active_ecommerce_flutter/services/auth_provider.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUserWithEmail({
    required String email,
    required String password,
  }) => provider.createUserWithEmail(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  }) => provider.loginWithEmail(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
