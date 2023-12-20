import 'package:active_ecommerce_flutter/features/auth/models/seller_group_item.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<FriendsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FriendsRequested>((event, emit) async {
      emit(FriendsLoadInProgress());

      List<SellerGroupItem>? sellers =
          await FirestoreRepository().getOtherSellersForSubCategory(
        subCategory: event.subCategory,
        locationFilterType: event.locationFilterType,
        userAddress: event.userAddress,
      );

      emit(FriendsLoadSuccess(sellers: sellers ?? []));
    });
  }
}
