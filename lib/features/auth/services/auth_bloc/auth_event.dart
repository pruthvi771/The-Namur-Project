import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailRequested(this.email, this.password);
}

class SignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailRequested(this.email, this.password);
}

class LogOutRequested extends AuthEvent {
  LogOutRequested();
}

class GoogleSignInRequested extends AuthEvent {
  GoogleSignInRequested();
}

class PhoneVerificationRequested extends AuthEvent {
  final String phoneNumber;

  PhoneVerificationRequested(this.phoneNumber);
}

class SignInWithPhoneNumberRequested extends AuthEvent {
  final String verificationId;
  final String otp;

  SignInWithPhoneNumberRequested(this.verificationId, this.otp);
}

class resetPasswordForEmailRequested extends AuthEvent {
  final String email;

  resetPasswordForEmailRequested(this.email);
}
