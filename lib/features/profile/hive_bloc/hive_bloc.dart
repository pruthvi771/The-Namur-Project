import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HiveBloc extends Bloc<HiveEvent, HiveState> {
  HiveBloc() : super(Loading()) {
    on<HiveDataRequested>((event, emit) async {
      // emit(Loading());

      var dataBox = Hive.box<ProfileData>('profileDataBox3');

      var savedData = dataBox.get('profile');

      if (savedData != null) {
        emit(HiveDataReceived(profileData: savedData));
      } else {
        emit(Error('No Data Found'));
        emit(HiveDataNotReceived());
      }
    });

    on<HiveAppendAddress>((event, emit) {
      BlocProvider.of<HiveBloc>(event.context).add(
        HiveDataRequested(),
      );
    });
  }
}
