import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable {}
//   final String? verificationId;

//   AuthState({this.verificationId});
// }

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends AuthState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class Success extends AuthState {
  @override
  List<Object?> get props => [];
}

class PhoneVerificationCompleted extends AuthState {
  final String? verificationId;

  PhoneVerificationCompleted({
    this.verificationId,
  });
  // }) : super(verificationId: verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class resetPasswordForEmailSent extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
  @override
  List<Object?> get props => [error];
}
