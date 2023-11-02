import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:bloc/bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<CartEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddToCartRequested>((event, emit) async {
      try {
        emit(CartLoading());
        await cartRepository.addToCart(
          productId: event.productId,
        );
        emit(AddToCartSuccessful());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in AddToCartRequested');
        print(e.toString());
      }
    });
  }
}
