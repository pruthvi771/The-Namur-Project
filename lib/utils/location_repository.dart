import 'dart:convert';
import 'dart:io';

import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:flutter/services.dart';

class LocationRepository {
  AuthRepository authRepository = AuthRepository();
  final FirestoreRepository firestoreRepository = FirestoreRepository();

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
    String jsonData = await rootBundle.loadString('assets/address.json');
    List<Map<String, dynamic>> addresses =
        List<Map<String, dynamic>>.from(json.decode(jsonData));

    return addresses.map((map) => map['district'].toString()).toSet().toList();
    // return addresses.map((map) => map['district'].toString()).toSet().toList();
    // return [];
  }

  Future<List<String>> getTaluksForDistrict({
    required String districtName,
  }) async {
    String jsonData = await rootBundle.loadString('assets/address.json');
    List<Map<String, dynamic>> addresses =
        List<Map<String, dynamic>>.from(json.decode(jsonData));

    return addresses
        .where((map) => map['district'] == districtName)
        .map((map) => map['TALUK'].toString())
        .toSet()
        .toList();
  }

  Future<List<String>> getGramPanchayatsForTaluk({
    required String taluk,
  }) async {
    String jsonData = await rootBundle.loadString('assets/address.json');
    List<Map<String, dynamic>> addresses =
        List<Map<String, dynamic>>.from(json.decode(jsonData));

    return addresses
        .where((map) => map['TALUK'] == taluk)
        .map((map) => map['Gram Panchayat'].toString())
        .toSet()
        .toList();
  }

  Future<List<String>> getVillagesForGramPanchayat({
    required String gramPanchayat,
  }) async {
    String jsonData = await rootBundle.loadString('assets/address.json');
    List<Map<String, dynamic>> addresses =
        List<Map<String, dynamic>>.from(json.decode(jsonData));

    return addresses
        .where((map) => map['Gram Panchayat'] == gramPanchayat)
        .map((map) => map['Village Name'].toString())
        .toSet()
        .toList();
  }
}
