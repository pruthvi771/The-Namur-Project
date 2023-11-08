import 'package:active_ecommerce_flutter/features/profile/services/friends_bloc/friends_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/friends_bloc/friends_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(Loading()) {
    // on<FriendsDataRequested>((event, emit) async {
    //   // emit(Loading());
    //   try {
    //     AuthUser user = AuthRepository().currentUser!;
    //     BuyerData buyerProfileData =
    //         await FirestoreRepository().getBuyerData(userId: user.userId);
    //     emit(ProfileDataReceived(buyerProfileData: buyerProfileData));
    //   } catch (e) {
    //     emit(Error('No Data Found'));
    //     emit(ProfileDataNotReceived());
    //   }
    // });
  }
}
