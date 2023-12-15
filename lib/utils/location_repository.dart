import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationRepository {
  AuthRepository authRepository = AuthRepository();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getDistrictsForPincode({
    required String pinCode,
  }) async {
    try {
      var postOfficeResponse =
          await authRepository.getLocationsForPincode(pinCode: pinCode);

      List<String> districtsList = [];

      for (var postOffice in postOfficeResponse!.postOffices) {
        if (!districtsList.contains(postOffice.district)) {
          districtsList.add(postOffice.district);
        }
      }

      return districtsList;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch locations. Please try again.');
    }
  }

  Future<List<String>> getAllDistricts() async {
    try {
      Set<String> districts = {};
      final addressSnapshot =
          await _firestore.collection('globaladdress').get();

      addressSnapshot.docs.forEach((element) {
        districts.add(element.data()['district']);
      });

      return districts.toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch locations. Please try again.');
    }
  }

  Future<List<String>> getTaluksForDistrict({
    required String districtName,
  }) async {
    try {
      Set<String> talukSet = {};
      final addressSnapshot = await _firestore
          .collection('globaladdress')
          .where('district', isEqualTo: districtName)
          .get();

      addressSnapshot.docs.forEach((element) {
        talukSet.add(element.data()['taluk']);
      });

      return talukSet.toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch locations. Please try again.');
    }
  }

  Future<List<String>> getGramPanchayatsForTaluk({
    required String taluk,
  }) async {
    try {
      Set<String> gramPanchayatSet = {};
      final addressSnapshot = await _firestore
          .collection('globaladdress')
          .where('taluk', isEqualTo: taluk)
          .get();

      addressSnapshot.docs.forEach((element) {
        gramPanchayatSet.add(element.data()['gramPanchayat']);
      });

      return gramPanchayatSet.toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch locations. Please try again.');
    }
  }

  Future<List<String>> getVillagesForGramPanchayat({
    required String gramPanchayat,
  }) async {
    try {
      Set<String> villageNameSet = {};
      final addressSnapshot = await _firestore
          .collection('globaladdress')
          .where('gramPanchayat', isEqualTo: gramPanchayat)
          .get();

      addressSnapshot.docs.forEach((element) {
        villageNameSet.add(element.data()['villageName']);
      });

      return villageNameSet.toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch locations. Please try again.');
    }
  }
}
