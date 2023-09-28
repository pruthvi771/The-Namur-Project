import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInWithEmailRequested extends AuthEvent {
  // final String email;
  // final String password;

  SignInWithEmailRequested();
}

class SignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailRequested(this.email, this.password);
}
