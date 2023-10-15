import 'dart:async';
import 'dart:convert';

import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/models/postoffice_response_model.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart'
    show
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        // PhoneAuthCredential,
        PhoneAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreRepository firestoreRepository = FirestoreRepository();

  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : AuthUser.fromFirebase(user);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not found. Please register first.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password. Please try again.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email. Please try again.');
      } else if (e.code == 'user-disabled') {
        throw Exception('User is disabled. Please contact support.');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> createUserWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      var userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      firestoreRepository.addUserToBuyerSellerCollections(
          userId: userCredentials.user!.uid,
          name: name,
          email: userCredentials.user!.email!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is not strong enough.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception(
            'The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Something went wrong. Please contact support.');
      } else {
        throw Exception('Something went wrong. Please try again later.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<void> logOut() async {
    // final user = _firebaseAuth.currentUser;

    // if (user != null) {
    try {
      await _firebaseAuth.signOut();
      try {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
      } catch (_) {
        // ignore
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw Exception('No internet connection');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<void> sendEmailVerification() async {
  //   final user = _firebaseAuth.currentUser;
  //   if (user != null) {
  //     await user.sendEmailVerification();
  //   } else {
  //     throw UserNotLoggedInAuthException();
  //   }
  // }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      var userCredential = await _firebaseAuth.signInWithCredential(credential);

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(userCredential.user!.uid)
          .get();

      if (!userSnapshot.exists) {
        firestoreRepository.addUserToBuyerSellerCollections(
            userId: userCredential.user!.uid,
            name: userCredential.user!.displayName!,
            email: userCredential.user!.email!,
            photoURL: userCredential.user!.photoURL!);
        await createEmptyHiveDataInstance(userCredential.user!.uid);
      } else {
        await syncFirestoreDataWithHive(userCredential.user!.uid);
      }

      // final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
            'This email is already in use by a different login method.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Something went wrong. Please contact support.');
      } else if (e.code == 'user-disabled') {
        throw Exception('User is disabled. Please contact support.');
      } else if (e.code == 'play-services-not-available') {
        throw Exception('Please install Google Play Store first.');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<String?> phoneNumberVerification({
    required String phone,
  }) async {
    try {
      Completer<String?> verificationIdCompleter = Completer<String?>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (_) {
          print('Phone number automatically verified and user signed in: ');
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.code);
          print(e.message);
          verificationIdCompleter.completeError(
              'Verification failed. Please check your phone number and try again.');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('OTP sent to your phone number');
          verificationIdCompleter.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      return verificationIdCompleter.future;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        throw Exception('Invalid phone number. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> loginWithPhone(
      {required String verificationId, required String otp}) async {
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await _firebaseAuth.signInWithCredential(credentials);
      final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();

      if (user == null) {
        throw Exception('Something went wrong. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception('Invalid OTP. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else if (e.code == 'session-expired') {
        throw Exception('OTP expired. Please try again.');
      } else {
        // print(e);
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      // print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> signupWithPhone({
    required String verificationId,
    required String phoneNumber,
    required String otp,
    required String username,
    required String email,
    required String addressName,
    required String districtName,
    required String addressCircle,
    required String addressRegion,
    required String pincode,
  }) async {
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      var userCredential =
          await _firebaseAuth.signInWithCredential(credentials);
      final user = currentUser;
      // return user != null ? user : throw UserNotFoundAuthException();

      if (user == null) {
        throw Exception('Something went wrong. Please try again.');
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(userCredential.user!.uid)
          .get();

      if (!userSnapshot.exists) {
        firestoreRepository.addUserToBuyerSellerCollections(
          userId: userCredential.user!.uid,
          name: username,
          email: email,
          phoneNumber: phoneNumber,
          pincode: pincode,
          addressName: addressName,
          districtName: districtName,
          addressCircle: addressCircle,
          addressRegion: addressRegion,
        );
      }

      var dataBox = Hive.box<ProfileData>('profileDataBox3');

      var address = Address()
        ..district = districtName
        ..taluk = addressRegion
        ..hobli = addressCircle
        ..village = addressName;

      var kyc = KYC()
        ..aadhar = ''
        ..pan = ''
        ..gst = '';

      var newData = ProfileData()
        ..id = 'profile'
        ..updated = false
        ..address = [address]
        ..kyc = kyc
        ..land = [];

      await dataBox.put(newData.id, newData);
      print('object created');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception('Invalid OTP. Please try again.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else if (e.code == 'session-expired') {
        throw Exception('OTP expired. Please try again.');
      } else {
        // print(e);
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      // print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> resetPasswordForEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('Invalid email');
      } else if (e.code == 'user-not-found') {
        throw Exception('User not found. Please register first.');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Maximum requests limit reached. Please try again later');
      } else {
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
      // throw GenericAuthException();
    }
  }

  Future<PostOfficeResponse?> getLocationsForPincode(
      {required String pinCode}) async {
    try {
      print('starting');
      var postOfficeResponse = await http
          .get(Uri.parse('https://api.postalpincode.in/pincode/$pinCode'));

      // if (postOfficeResponse.statusCode == 200) {
      var jsonResponse = json.decode(postOfficeResponse.body);

      print(jsonResponse);
      if (jsonResponse[0]['Status'] == 'Success') {
        print('success');
        // return PostOfficeResponse.fromJson(jsonResponse);
        return PostOfficeResponse.fromJson(jsonResponse[0]);
      } else {
        print('error happened in forecast');
        throw Exception('Failed to fetch locations. Please try again.');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch locations. Please try again.');
    }
  }

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
      // var hiveBox = await Hive.openBox<ProfileData>('profileDataBox3');
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
}
