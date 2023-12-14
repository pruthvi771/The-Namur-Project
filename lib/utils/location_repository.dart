import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';

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
}
