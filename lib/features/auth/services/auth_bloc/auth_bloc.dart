import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Future<void> syncFirestoreDataWithHive(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('buyer').doc(userId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;

      // Separate data into different variables
      var updated = data['profileData']['updated'];

      var addresses = (data['profileData']['address'] as List)
          .map((item) => Address()
            ..district = item['district']
            ..taluk = item['taluk']
            ..hobli = item['hobli']
            ..village = item['village'])
          .toList();

      var kyc = KYC()
        ..aadhar = data['profileData']['kyc']['aadhar']
        ..pan = data['profileData']['kyc']['pan']
        ..gst = data['profileData']['kyc']['gst'];

      var lands = (data['profileData']['land'] as List)
          .map((item) => Land()
            ..village = item['village']
            ..syno = item['syno']
            ..area = item['area']
            ..crops = (item['crops'] as List)
                .map((cropItem) => Crop()
                  ..name = cropItem['name']
                  ..yieldOfCrop = cropItem['yieldOfCrop'])
                .toList()
            ..equipments = List<String>.from(item['equipments']))
          .toList();

      // Create ProfileData object by combining separated variables
      var profileData = ProfileData()
        ..id = 'profile'
        ..updated = updated
        ..address = addresses
        ..kyc = kyc
        ..land = lands;

      // Initialize Hive and save data
      // var hiveBox = await Hive.openBox('profileDataBox3');
      var dataBox = Hive.box<ProfileData>('profileDataBox3');
      await dataBox.put(profileData.id, profileData);
    }
  }

  void saveProfileDataToFirestore(ProfileData profileData, userId) {
    FirebaseFirestore.instance
        .collection(
            'buyer') // Replace 'users' with your desired collection name
        .doc(userId) // Use the user's ID as the document ID
        .update({
          'profileData': {
            'updated': profileData.updated,
            'address': profileData.address
                .map((address) => {
                      'district': address.district,
                      'taluk': address.taluk,
                      'hobli': address.hobli,
                      'village': address.village,
                    })
                .toList(),
            'kyc': {
              'aadhar': profileData.kyc.aadhar,
              'pan': profileData.kyc.pan,
              'gst': profileData.kyc.gst,
            },
            'land': profileData.land
                .map((land) => {
                      'village': land.village,
                      'syno': land.syno,
                      'area': land.area,
                      'crops': land.crops
                          .map((crop) => {
                                'name': crop.name,
                                'yieldOfCrop': crop.yieldOfCrop,
                              })
                          .toList(),
                      'equipments': land.equipments,
                    })
                .toList(),
          }
        })
        .then((value) => print("ProfileData added to Firestore"))
        .catchError((error) => print("Failed to add ProfileData: $error"));
  }

  // Future<void> createEmptyHiveDataInstance(String userId) async {
  //   var dataBox = Hive.box<ProfileData>('profileDataBox3');

  //   var kyc = KYC()
  //     ..aadhar = ''
  //     ..pan = ''
  //     ..gst = '';

  //   var emptyProfileData = ProfileData()
  //     ..id = 'profile'
  //     ..updated = true
  //     ..address = []
  //     ..kyc = kyc
  //     ..land = [];
  //   dataBox.put(emptyProfileData.id, emptyProfileData);

  //   // Initialize Hive and save data
  //   await dataBox.put(emptyProfileData.id, emptyProfileData);

  //   saveProfileDataToFirestore(emptyProfileData, userId);
  // }

  Future<void> createEmptyHiveDataInstance(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('buyer').doc(userId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;

      // Separate data into different variables
      var addressObject = data['address'];

      var address = Address()
        ..district = addressObject['district']
        ..taluk = addressObject['region']
        ..hobli = addressObject['circle']
        ..village = addressObject['name'];

      var dataBox = Hive.box<ProfileData>('profileDataBox3');

      var kyc = KYC()
        ..aadhar = ''
        ..pan = ''
        ..gst = '';

      var emptyProfileData = ProfileData()
        ..id = 'profile'
        ..updated = true
        ..address = [address]
        ..kyc = kyc
        ..land = [];
      dataBox.put(emptyProfileData.id, emptyProfileData);

      // Initialize Hive and save data
      await dataBox.put(emptyProfileData.id, emptyProfileData);

      saveProfileDataToFirestore(emptyProfileData, userId);
    }
  }

  final AuthRepository authRepository;
  final FirestoreRepository firestoreRepository;
  AuthBloc({required this.authRepository, required this.firestoreRepository})
      : super(UnAuthenticated()) {
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
        var registeredPhoneNumbers;
        registeredPhoneNumbers =
            await firestoreRepository.getAllRegisteredPhoneNumbers();
        // print('YOUR NUMBER: ${event.phoneNumber}');

        if (registeredPhoneNumbers.contains(event.phoneNumber)) {
          // throw Exception('Phone number already registered.');

          print('PHONE NUMBER EXISTS IN THE DATABASE');
          final verificationId = await authRepository.phoneNumberVerification(
              phone: event.phoneNumber);
          emit(PhoneVerificationCompleted(verificationId: verificationId));
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
        // print('THIS IS A DRILL SIGN UP VERIFICATION REQUESTED.');
        var registeredPhoneNumbers;
        registeredPhoneNumbers =
            await firestoreRepository.getAllRegisteredPhoneNumbers();
        print('YOUR NUMBER: ${event.phoneNumber}');
        for (var number in registeredPhoneNumbers) {
          print(number);
        }

        if (registeredPhoneNumbers.contains(event.phoneNumber)) {
          // throw Exception('Phone number already registered.');
          print('PHONE NUMBER EXISTS IN THE DATABASE');
          emit(AuthError('Phone number already registered.'));
          emit(UnAuthenticated());
        } else {
          print('PHONE NUMBER DOESN NOT EXIST IN THE DATABASE');
          final verificationId = await authRepository.phoneNumberVerification(
              phone: event.phoneNumber);
          emit(
              SignUpPhoneVerificationCompleted(verificationId: verificationId));
          print('sign up verification completed emitting');
          emit(Loading());
          print('sign up verification completed emitted');
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignInWithPhoneNumberRequested>((event, emit) async {
      emit(Loading());
      try {
        var user = await authRepository.loginWithPhone(
            verificationId: event.verificationId, otp: event.otp);
        var userId = auth.FirebaseAuth.instance.currentUser!.uid;
        await syncFirestoreDataWithHive(userId);
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
        var userId = auth.FirebaseAuth.instance.currentUser!.uid;
        await createEmptyHiveDataInstance(userId);
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
        emit(LocationsForPincodeReceived(
            postOfficeResponse: postOfficeResponse!));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(LocationsForPincodeNotReceived());
      }
    });
  }
}
