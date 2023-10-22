import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sell/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sell/services/bloc/sell_event.dart';
import 'package:active_ecommerce_flutter/features/sell/services/bloc/sell_state.dart';
import 'package:active_ecommerce_flutter/features/sell/services/sell_repository.dart';
import 'package:bloc/bloc.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final AuthRepository authRepository;
  final SellRepository sellRepository;

  SellBloc({required this.authRepository, required this.sellRepository})
      : super(SellInitial()) {
    on<SellEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddProductRequested>((event, emit) async {
      var currentUser = authRepository.currentUser!;

      try {
        var docId = await sellRepository.addProductBuying(
          productName: event.productName,
          productDescription: event.productDescription,
          productPrice: event.productPrice,
          productQuantity: event.productQuantity,
          priceType: event.priceType,
          category: event.category,
          subCategory: event.subCategory,
          subSubCategory: event.subSubCategory,
          imageURL: "",
          userId: currentUser.userId,
        );

        await sellRepository.saveProductImage(file: event.image, docId: docId!);

        emit(ProductAddedSuccessfully());

        // emit(SellAddProductSuccessState());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened');
      }
    });

    on<ProductsForSubCategoryRequested>((event, emit) async {
      try {
        emit(ProductLoading());
        List<SellProduct> products =
            await sellRepository.getProducts(subCategory: event.subCategory);

        emit(ProductsForSubCategoryReceived(products: products));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });

    on<DeleteProductRequested>((event, emit) async {
      try {
        await sellRepository.deleteProduct(productId: event.productId);
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in DeleteProductRequested');
        print(e.toString());
      }
    });
  }
}
