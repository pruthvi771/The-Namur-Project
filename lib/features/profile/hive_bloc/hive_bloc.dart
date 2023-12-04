import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HiveBloc extends Bloc<HiveEvent, HiveState> {
  FirestoreRepository firestoreRepository = FirestoreRepository();

  HiveBloc() : super(Loading()) {
    on<HiveDataRequested>((event, emit) async {
      // emit(Loading());

      var dataBox = Hive.box<ProfileData>('profileDataBox3');

      var savedData = dataBox.get('profile');

      if (savedData != null) {
        emit(HiveDataReceived(profileData: savedData));
        print('-- emitted hive data--- ');
      } else {
        emit(Error('No Data Found'));
        emit(HiveDataNotReceived());
        print('-- something wrong --- ');
      }
    });

    on<HiveAppendAddress>((event, emit) {
      BlocProvider.of<HiveBloc>(event.context).add(
        HiveDataRequested(),
      );
    });

    on<HiveLocationDataRequested>((event, emit) async {
      emit(Loading());

      var dataBox = Hive.box<SecondaryLocations>('secondaryLocationsBox');

      var savedData = dataBox.get('secondaryLocations');
      // savedData.address

      if (savedData != null) {
        emit(HiveLocationDataReceived(locationData: savedData.address));
      } else if (savedData == null) {
        emit(HiveLocationDataReceived(locationData: []));
      } else {
        emit(Error('No Data Found'));
        emit(HiveDataNotReceived());
      }
    });

    on<SyncHiveToFirestoreRequested>((event, emit) async {
      emit(Loading());

      AuthUser user = AuthRepository().currentUser!;

      await firestoreRepository.saveProfileDataToFirestore(
        profileData: event.profileData,
        userId: user.userId,
      );
    });
  }
}
