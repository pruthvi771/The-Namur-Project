import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_bloc/buy_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_bloc/buy_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_repository.dart';
import 'package:bloc/bloc.dart';

class BuyBloc extends Bloc<BuyEvent, BuyState> {
  final BuyRepository buyRepository;

  BuyBloc({required this.buyRepository}) : super(BuyInitial()) {
    on<BuyEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<BuyProductsForSubCategoryRequested>((event, emit) async {
      try {
        emit(BuyLoading());
        List<SellProduct> products =
            await buyRepository.getProductsForSubCategory(
          subCategory: event.subCategory,
          // isSecondHand: event.isSecondHand,
        );

        // print(products[0].productName);

        emit(BuyProductsForSubCategoryReceived(products: products));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });
  }
}
