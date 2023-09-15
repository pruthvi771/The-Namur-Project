import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
