import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<SignInWithEmailRequested>((event, emit) async {
      print('SignInWithEmailRequested started');
      emit(Loading());
      try {
        await authRepository.loginWithEmail(
            email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignUpWithEmailRequested>((event, emit) async {
      emit(Loading());
      try {
        var userCredentials = await authRepository.createUserWithEmail(
          email: event.email, password: event.password, name: event.name,
          // firstName: event.firstName,
          // lastName: event.lastName,
          // businessName: event.businessName,
        );
        emit(Success());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<LogOutRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.logOut();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.loginWithGoogle();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<PhoneVerificationRequested>((event, emit) async {
      emit(Loading());
      try {
        final verificationId = await authRepository.phoneNumberVerification(
            phone: event.phoneNumber);
        emit(PhoneVerificationCompleted(verificationId: verificationId));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignInWithPhoneNumberRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.loginWithPhone(
            verificationId: event.verificationId, otp: event.otp);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<resetPasswordForEmailRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.resetPasswordForEmail(email: event.email);
        emit(resetPasswordForEmailSent());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
  }
}
