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

    on<RatingUpdateRequested>((event, emit) async {
      // try {
      emit(BuyLoading());

      await buyRepository.updateRatingInOrderDoc(
        rating: event.rating,
        orderId: event.orderId,
        indexInOrderItems: event.indexInOrderItems,
      );

      await buyRepository.updateRatingInProductDoc(
        rating: event.rating,
        productId: event.productId,
        isFirstTime: event.isFirstTime,
        initialRatingInProductDoc: event.initialRatingInProductDoc,
      );

      emit(RatingDataReceived(rating: event.rating));
      // } catch (e) {
      //   // emit(SellAddProductErrorState(message: e.toString()));
      //   print('error happened in RatingUpdateRequested');
      //   print(e.toString());
      // }
    });

    // on<RatingDataRequested>((event, emit) async {
    //   try {
    //     emit(BuyLoading());

    //     double rating = await buyRepository.getRatingFromOrderDoc(
    //       orderId: event.orderId,
    //       indexInOrderItems: event.indexInOrderItems,
    //     );

    //     emit(RatingDataReceived(rating: rating));
    //   } catch (e) {
    //     // emit(SellAddProductErrorState(message: e.toString()));
    //     print('error happened in RatingUpdateRequested');
    //     print(e.toString());
    //   }
    // });
  }
}
