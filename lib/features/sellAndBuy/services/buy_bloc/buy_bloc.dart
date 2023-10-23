import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
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
        List<SellProduct> products = await buyRepository
            .getProductsForSubCategory(subCategory: event.subCategory);

        // print(products[0].productName);

        emit(BuyProductsForSubCategoryReceived(products: products));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });

    // on<SellerDataRequested>((event, emit) async {
    //   try {
    //     // emit(BuyLoading());
    //     BuyerData sellerData =
    //         await buyRepository.getSellerData(userId: event.sellerId);

    //     // print(products[0].productName);

    //     emit(SellerDataReceived(sellerData: sellerData));
    //   } catch (e) {
    //     // emit(SellAddProductErrorState(message: e.toString()));
    //     print('error happened in ProductsForSubCategoryRequested');
    //     print(e.toString());
    //   }
    // });

    // on<DeleteProductRequested>((event, emit) async {
    //   try {
    //     await sellRepository.deleteProduct(productId: event.productId);
    //     emit(ProductAddEditDeleteSuccessfully());
    //   } catch (e) {
    //     // emit(SellAddProductErrorState(message: e.toString()));
    //     print('error happened in DeleteProductRequested');
    //     print(e.toString());
    //   }
    // });
  }
}
