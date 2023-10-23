import 'dart:async';
import 'dart:typed_data';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';

class FirestoreRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addUserToBuyerSellerCollections({
    required String userId,
    required String name,
    required String email,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      _firestore.collection('buyer').doc(userId).set({
        'name': name,
        'email': email,
        'phone number': phoneNumber ?? '',
        'location_id': '',
        'photoURL': photoURL ?? '',
        // add other fields as needed
      });

      _firestore.collection('seller').doc(userId).set({
        'name': name,
        'email': email,
        'phone number': phoneNumber ?? '',
        'location_id': '',
        'Products_Buy': '',
        'adhaar_id': '',
        'adhaar_id_verified': false,
        'GST': '',
        'GST_verified': false,
        'PAN': '',
        'PAN_verified': false,
        'profile_complete': false,
        'photoURL': photoURL ?? '',
        // add other fields as needed
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<BuyerData> getBuyerData({
    required String userId,
  }) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(userId)
          .get();
      return BuyerData.fromJson(userSnapshot.data() as Map<String, dynamic>);
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<String> uploadImagetoFirebase(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> saveProfileImage({
    required Uint8List file,
  }) async {
    var user = FirebaseAuth.instance.currentUser!;
    try {
      var photoURL =
          await uploadImagetoFirebase('${user.uid}/profileImage', file);
      await _firestore.collection('buyer').doc(user.uid).update({
        'photoURL': photoURL,
      });
      await _firestore.collection('seller').doc(user.uid).update({
        'photoURL': photoURL,
      });
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<List<String>> getAllRegisteredPhoneNumbers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('buyer').get();

      List<String> phoneNumbers = querySnapshot.docs
          .map((doc) => doc.get('phone number') as String)
          .toList();

      return phoneNumbers;
    } catch (e) {
      // Handle errors here
      throw Exception(
          'Something went wrong. Please try again later or contact support.');
      // return [];
    }
  }

  Future<void> syncFirestoreDataWithHive({
    required String userId,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('buyer').doc(userId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;

      // Separate data into different variables
      var updated = data['profileData']['updated'];

      var addresses = (data['profileData']['address'] as List)
          .map((item) => Address()
            ..district = item['district']
            ..taluk = item['taluk']
            ..hobli = item['hobli']
            ..village = item['village']
            ..pincode = item['pincode'])
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

      var dataBox = Hive.box<ProfileData>('profileDataBox3');
      await dataBox.put(profileData.id, profileData);
    }
  }

  Future<void> saveProfileDataToFirestore({
    required ProfileData profileData,
    required userId,
  }) async {
    _firestore
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
                      'pincode': address.pincode
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

  Future<void> createEmptyHiveDataInstance({
    required String userId,
    bool isAddressAvailable = false,
    String? district,
    String? taluk,
    String? hobli,
    String? village,
    String? pincode,
  }) async {
    var address = Address()
      ..district = isAddressAvailable ? district! : ''
      ..taluk = isAddressAvailable ? taluk! : ''
      ..hobli = isAddressAvailable ? hobli! : ''
      ..village = isAddressAvailable ? village! : ''
      ..pincode = isAddressAvailable ? pincode! : '';

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var kyc = KYC()
      ..aadhar = ''
      ..pan = ''
      ..gst = '';

    var emptyProfileData = ProfileData()
      ..id = 'profile'
      ..updated = true
      ..address = isAddressAvailable ? [address] : []
      ..kyc = kyc
      ..land = [];

    dataBox.put(emptyProfileData.id, emptyProfileData);

    // Initialize Hive and save data
    await dataBox.put(emptyProfileData.id, emptyProfileData);

    saveProfileDataToFirestore(profileData: emptyProfileData, userId: userId);
  }

  Future<int> countUsersWithPincode(String pincode) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('buyer')
              .where('profileData.address.pincode', isEqualTo: pincode)
              .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error counting users with pincode: $e');
      return 0; // Return 0 in case of an error
    }
  }
}
