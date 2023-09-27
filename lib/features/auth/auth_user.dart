import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

class AuthUser {
  // final bool isEmailVerified;
  final String userId;
  const AuthUser(this.userId);

  // factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
  factory AuthUser.fromFirebase(User user) => AuthUser(user.uid);
}
