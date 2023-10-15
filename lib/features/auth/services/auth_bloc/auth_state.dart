import 'package:active_ecommerce_flutter/features/auth/models/postoffice_response_model.dart';
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

class SignUpLoading extends AuthState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OtpLoading extends AuthState {
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

class SignUpPhoneVerificationCompleted extends AuthState {
  final String? verificationId;

  SignUpPhoneVerificationCompleted({
    this.verificationId,
  });
  // }) : super(verificationId: verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class LocationsForPincodeReceived extends AuthState {
  final PostOfficeResponse postOfficeResponse;

  LocationsForPincodeReceived({
    required this.postOfficeResponse,
  });
  // }) : super(verificationId: verificationId);
  @override
  List<Object?> get props => [postOfficeResponse];
}

class LocationsForPincodeLoading extends AuthState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LocationsForPincodeNotReceived extends AuthState {
  @override
  List<Object?> get props => throw UnimplementedError();
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
