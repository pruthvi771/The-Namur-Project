import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_repository.dart';
import 'package:bloc/bloc.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  final RentRepository rentRepository;

  RentBloc({required this.rentRepository}) : super(RentInitial()) {
    on<RentEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<RentProductRequested>((event, emit) async {
      try {
        emit(RentLoading());
        // List<SellProduct> products =
        //     await buyRepository.getProductsForSubCategory(
        //   subCategory: event.subCategory,
        //   // isSecondHand: event.isSecondHand,
        // );

        // // print(products[0].productName);

        // emit(BuyProductsForSubCategoryReceived(products: products));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });
  }
}
