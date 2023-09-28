import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<SignInWithEmailRequested>((event, emit) async {
      print('function called');
      emit(Authenticated());
      Future.delayed(Duration(seconds: 3)).then((value) {
        emit(Authenticated());
      });
      // try {
      //   await authRepository.loginWithEmail(
      //       email: event.email, password: event.password);
      //   emit(Authenticated());
      // } catch (e) {
      //   emit(AuthError(e.toString()));
      //   emit(UnAuthenticated());
      // }
    });

    on<SignUpWithEmailRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.createUserWithEmail(
            email: event.email, password: event.password
            // firstName: event.firstName,
            // lastName: event.lastName,
            // businessName: event.businessName,
            );
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    // on<LogOutRequested>((event, emit) async {
    //   emit(Loading());
    //   await authRepository.signOut();
    //   emit(UnAuthenticated());
    // });
  }
}
