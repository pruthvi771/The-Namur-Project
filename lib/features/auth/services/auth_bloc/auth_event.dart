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
  final String name;

  SignUpWithEmailRequested(this.email, this.password, this.name);
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

class SignUpPhoneVerificationRequested extends AuthEvent {
  final String phoneNumber;

  SignUpPhoneVerificationRequested(this.phoneNumber);
}

class SignUpWithPhoneNumberRequested extends AuthEvent {
  final String verificationId;
  final String otp;
  final String name;
  final String email;
  final String phoneNumber;
  final String pincode;
  final String addressName;
  final String districtName;
  final String addressCircle;
  final String addressRegion;

  SignUpWithPhoneNumberRequested(
      this.verificationId,
      this.otp,
      this.name,
      this.email,
      this.phoneNumber,
      this.pincode,
      this.addressName,
      this.districtName,
      this.addressCircle,
      this.addressRegion);
}

class LocationsForPincodeRequested extends AuthEvent {
  final String pinCode;

  LocationsForPincodeRequested(this.pinCode);
}

class LandLocationsForPincodeRequested extends AuthEvent {
  final String pinCode;

  LandLocationsForPincodeRequested(this.pinCode);
}

class resetPasswordForEmailRequested extends AuthEvent {
  final String email;

  resetPasswordForEmailRequested(this.email);
}
