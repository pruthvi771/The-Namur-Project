import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(Loading()) {
    on<ProfileDataRequested>((event, emit) async {
      // emit(Loading());
      try {
        AuthUser user = AuthRepository().currentUser!;
        BuyerData buyerProfileData =
            await FirestoreRepository().getBuyerData(userId: user.userId);
        emit(ProfileDataReceived(buyerProfileData: buyerProfileData));
      } catch (e) {
        emit(Error('No Data Found'));
        emit(ProfileDataNotReceived());
      }
    });

    on<ProfileImageUpdateRequested>((event, emit) async {
      emit(Loading());
      try {
        await FirestoreRepository().saveProfileImage(file: event.file);
        emit(ProfileImageUpdated());
      } catch (e) {
        emit(Error('Could Not Update Image. Please Try Again'));
      }
    });
  }
}
