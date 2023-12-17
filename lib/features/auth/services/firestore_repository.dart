import 'dart:async';
import 'dart:typed_data';
import 'package:active_ecommerce_flutter/features/auth/models/seller_group_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
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
    bool googleSignIn = false,
  }) async {
    try {
      _firestore.collection('buyer').doc(userId).set({
        'name': name,
        'email': email,
        'authMethod': googleSignIn ? 'google' : 'phone',
        'phone number': phoneNumber ?? '',
        'location_id': '',
        'photoURL': photoURL ?? '',
        // add other fields as needed
      });

      _firestore.collection('seller').doc(userId).set({
        'name': name,
        'email': email,
        'authMethod': googleSignIn ? 'google' : 'phone',
        'phone number': phoneNumber ?? '',
        // 'location_id': '',
        // 'Products_Buy': '',
        // 'adhaar_id': '',
        // 'adhaar_id_verified': false,
        // 'GST': '',
        // 'GST_verified': false,
        // 'PAN': '',
        // 'PAN_verified': false,
        // 'profile_complete': false,
        'photoURL': photoURL ?? '',
        'products': [],
        'secondHandProducts': [],
        // 'onRent': []
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

  Future<BuyerData> updateUsername({
    required String userId,
    required String name,
  }) async {
    try {
      // Reference to the Firestore collection and document
      var userDocument1 = _firestore.collection('buyer').doc(userId);

      // Update the 'name' field with the new value
      await userDocument1.update({
        'name': name,
      });

      var userDocument2 = _firestore.collection('seller').doc(userId);

      // Update the 'name' field with the new value
      await userDocument2.update({
        'name': name,
      });

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

  Future<SellerDataForFriendsScreen> getSellerData({
    required String userId,
  }) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .doc(userId)
          .get();
      return SellerDataForFriendsScreen.fromJson(
          userSnapshot.data() as Map<String, dynamic>);
    } catch (_) {
      print(_);
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<String?> getSubCategoryName({required String productId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productDoc =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

      // Check if the document exists
      if (productDoc.exists) {
        return productDoc.data()?['subCategory'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching product sub category: $e');
      return null;
    }
  }

  Future<List<SellerGroupItem>?> getOtherSellersForSubCategory({
    required String subCategory,
    required LocationFilterType locationFilterType,
    required Address userAddress,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where(FieldPath.documentId, isNotEqualTo: null)
              .where('subCategory', isEqualTo: subCategory)
              .get();

      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      // print(documents);

      List sellerIDs = [];
      List<SellerGroupItem> sellerDetails = [];

      for (var document in documents) {
        Map<String, dynamic> data = document.data()!;
        if (!sellerIDs.contains(data['sellerId'])) {
          sellerIDs.add(data['sellerId']);
        }
      }

      print(sellerIDs);

      for (var sellerId in sellerIDs) {
        DocumentSnapshot<Map<String, dynamic>> productDoc =
            await FirebaseFirestore.instance
                .collection('seller')
                .doc(sellerId)
                .get();
        if (locationFilterType == LocationFilterType.district) {
          if (productDoc.data()!['district'] != userAddress.district) {
            continue;
          }
        } else if (locationFilterType == LocationFilterType.taluk) {
          if (productDoc.data()!['taluk'] != userAddress.taluk) {
            continue;
          }
        } else if (locationFilterType == LocationFilterType.gramPanchayat) {
          if (productDoc.data()!['gramPanchayat'] !=
              userAddress.gramPanchayat) {
            continue;
          }
        } else if (locationFilterType == LocationFilterType.village) {
          if (productDoc.data()!['villageName'] != userAddress.village) {
            continue;
          }
        }
        sellerDetails.add(
          SellerGroupItem(
            name: productDoc.data()!['name'],
            imageURL: productDoc.data()!['photoURL'],
            sellerId: sellerId,
            phoneNumber: productDoc.data()!['phone number'],
          ),
        );
      }
      return sellerDetails;
    } catch (e) {
      print('Error fetching product sub category: $e');
      return null;
    }
  }

  Future<String> uploadImagetoFirebase(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child('users/$childName');
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
            ..gramPanchayat = item['gramPanchayat']
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
                  ..yieldOfCrop = cropItem['yieldOfCrop']
                  ..id = cropItem['id'])
                .toList()
            ..animals = (item['animals'] as List)
                .map((animalItem) => Animal()
                  ..name = animalItem['name']
                  ..quantity = animalItem['quantity'])
                .toList()
            ..equipments = List<String>.from(item['equipments']))
          .toList();
      //   ..equipments = List<String>.from(item['equipments']))
      // .toList()
      //  ..animal = (item['animals'] as List)
      //       .map((animalItem) => Animal()
      //         ..name = animalItem['name']
      //         ..quantity = animalItem['quantity'])
      //       .toList();

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
                      'gramPanchayat': address.gramPanchayat,
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
                                'id': crop.id,
                              })
                          .toList(),
                      'equipments': land.equipments,
                      'animals': land.animals
                          .map((animal) => {
                                'name': animal.name,
                                'quantity': animal.quantity,
                              })
                          .toList(),
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
    String? gramPanchayat,
    String? village,
    String? pincode,
  }) async {
    var address = Address()
      ..district = isAddressAvailable ? district! : ''
      ..taluk = isAddressAvailable ? taluk! : ''
      ..gramPanchayat = isAddressAvailable ? gramPanchayat! : ''
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

  Future<bool> isGoogleSignedIn(String phone) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('buyer')
              .where('phone number', isEqualTo: phone)
              .get();

      return querySnapshot.docs[0].data()['authMethod'] == 'google';
    } catch (e) {
      print('Error getting user id by phone: $e');
      return false; // Return empty string in case of an error
    }
  }
}
