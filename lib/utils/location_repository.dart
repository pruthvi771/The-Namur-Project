import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/utils/globaladdress.dart';

class LocationRepository {
  AuthRepository authRepository = AuthRepository();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  List<Map> addresses = globaladdress;

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
    return addresses.map((map) => map['district'].toString()).toSet().toList();
  }

  List<String> getTaluksForDistrict({
    required String districtName,
  }) {
    return addresses
        .where((map) => map['district'] == districtName)
        .map((map) => map['TALUK'].toString())
        .toSet()
        .toList();
  }

  List<String> getGramPanchayatsForTaluk({
    required String taluk,
  }) {
    return addresses
        .where((map) => map['TALUK'] == taluk)
        .map((map) => map['Gram Panchayat'].toString())
        .toSet()
        .toList();
  }

  List<String> getVillagesForGramPanchayat({
    required String gramPanchayat,
  }) {
    return addresses
        .where((map) => map['Gram Panchayat'] == gramPanchayat)
        .map((map) => map['Village Name'].toString())
        .toSet()
        .toList();
  }
}
