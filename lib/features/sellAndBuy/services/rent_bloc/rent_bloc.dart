import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_repository.dart';
import 'package:bloc/bloc.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  final RentRepository rentRepository;
  final AuthRepository authRepository;

  RentBloc({required this.rentRepository, required this.authRepository})
      : super(RentInitial()) {
    on<RentEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<RentProductRequested>((event, emit) async {
      try {
        emit(RentLoading());
        var currentUser = authRepository.currentUser!;
        // List<SellProduct> products =
        //     await buyRepository.getProductsForSubCategory(
        //   subCategory: event.subCategory,
        //   // isSecondHand: event.isSecondHand,
        // );

        String? documentId = await rentRepository.addRentOrderDocument(
          buyerId: currentUser.userId,
          locationName: event.locationName,
          sellerId: event.sellerId,
          bookedSlot: event.bookedSlot,
          orderItems: event.orderItems,
          bookedDate: event.bookedDate,
          numberOfHalfHours: event.numberOfHalfHours,
        );

        emit(RentSuccess(documentId: documentId!));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });
  }
}
