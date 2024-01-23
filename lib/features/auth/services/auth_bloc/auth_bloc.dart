import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';

import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FirestoreRepository firestoreRepository;
  AuthBloc({required this.authRepository, required this.firestoreRepository})
      : super(UnAuthenticated()) {
    on<SignInWithEmailRequested>((event, emit) async {
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
        await authRepository.createUserWithEmail(
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
        bool isNewAccount = await authRepository.loginWithGoogle();
        if (isNewAccount) {
          emit(NeedToAddPhoneNumberState());
        } else {
          emit(Authenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<PhoneVerificationRequested>((event, emit) async {
      emit(Loading());
      try {
        var registeredPhoneNumbers;
        registeredPhoneNumbers =
            await firestoreRepository.getAllRegisteredPhoneNumbers();
        //

        if (registeredPhoneNumbers.contains(event.phoneNumber)) {
          bool isGoogleSignedIn =
              await firestoreRepository.isGoogleSignedIn(event.phoneNumber);

          if (!isGoogleSignedIn) {
            final verificationId = await authRepository.phoneNumberVerification(
                phone: event.phoneNumber);
            emit(PhoneVerificationCompleted(verificationId: verificationId));
          } else {
            emit(AuthError(
                'You Used Google Auth for Sign Up. Kindly Login with Google.'));
            emit(UnAuthenticated());
          }
        } else {
          emit(AuthError('User Not Found. Please Register First.'));
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignUpPhoneVerificationRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        //
        var registeredPhoneNumbers;
        registeredPhoneNumbers =
            await firestoreRepository.getAllRegisteredPhoneNumbers();

        for (var number in registeredPhoneNumbers) {}

        if (registeredPhoneNumbers.contains(event.phoneNumber)) {
          // throw Exception('Phone number already registered.');

          emit(AuthError('Phone number already registered.'));
          emit(UnAuthenticated());
        } else {
          final verificationId = await authRepository.phoneNumberVerification(
              phone: event.phoneNumber);
          emit(
              SignUpPhoneVerificationCompleted(verificationId: verificationId));

          emit(Loading());
        }
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

    on<SignUpWithPhoneNumberRequested>((event, emit) async {
      emit(OtpLoading());
      try {
        await authRepository.signupWithPhone(
          verificationId: event.verificationId,
          otp: event.otp,
          username: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
          pincode: event.pincode,
          addressName: event.addressName,
          districtName: event.districtName,
          addressCircle: event.addressCircle,
          addressRegion: event.addressRegion,
        );
        // var userId = auth.FirebaseAuth.instance.currentUser!.uid;
        // await createEmptyHiveDataInstance(userId);
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

    on<LocationsForPincodeRequested>((event, emit) async {
      emit(LocationsForPincodeLoading());
      try {
        var postOfficeResponse =
            await authRepository.getLocationsForPincode(pinCode: event.pinCode);

        if (postOfficeResponse == null) {
          emit(LocationsForPincodeNotReceived());
          return;
        }
        emit(LocationsForPincodeReceived(
            postOfficeResponse: postOfficeResponse));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(LocationsForPincodeNotReceived());
      }
    });

    on<LandLocationsForPincodeRequested>((event, emit) async {
      emit(LandLocationsForPincodeLoading());
      try {
        var postOfficeResponse =
            await authRepository.getLocationsForPincode(pinCode: event.pinCode);

        if (postOfficeResponse == null) {
          emit(LandLocationsForPincodeNotReceived());
          return;
        }

        emit(LandLocationsForPincodeReceived(
            postOfficeResponse: postOfficeResponse));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(LandLocationsForPincodeNotReceived());
      }
    });
  }
}
