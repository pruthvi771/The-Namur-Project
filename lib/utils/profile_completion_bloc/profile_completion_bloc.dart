import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/utils/profile_completion_bloc/profile_completion_event.dart';
import 'package:active_ecommerce_flutter/utils/profile_completion_bloc/profile_completion_state.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileCompletionBloc
    extends Bloc<ProfileCompletionEvent, ProfileCompletionState> {
  ProfileCompletionBloc() : super(ProfileCompletionLoading()) {
    on<ProfileCompletionDataRequested>((event, emit) async {
      ProfileData profileData;

      var dataBox = Hive.box<ProfileData>('profileDataBox3');

      var savedData = dataBox.get('profile');
      if (savedData == null) {
        User? user = FirebaseAuth.instance.currentUser;
        profileData = await FirestoreRepository()
            .createEmptyHiveDataInstance(userId: user!.uid);
      } else {
        profileData = savedData;
      }

      var tempProgress = 0.0;

      if (!(profileData.address.length == 0)) {
        tempProgress += 0.2;
      }
      if (profileData.kyc.aadhar.isNotEmpty) {
        tempProgress += 0.2;
      }
      int cropCount = 0;

      for (Land land in profileData.land) {
        cropCount += land.crops.length;
      }

      if (cropCount > 0) {
        tempProgress += 0.2;
      }

      int machineCount = 0;

      for (Land land in profileData.land) {
        machineCount += land.equipments.length;
      }

      if (machineCount > 0) {
        tempProgress += 0.2;
      }

      if (!(profileData.land.length == 0)) {
        tempProgress += 0.2;
      }

      emit(ProfileCompletionDataReceived(profileProgress: tempProgress));
    });
  }
}
