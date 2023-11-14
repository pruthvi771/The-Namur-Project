import 'package:active_ecommerce_flutter/features/sellAndBuy/models/cart_product.dart';
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
          quantity: 1,
        );
        emit(AddToCartSuccessful(quantity: 1));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in AddToCartRequested');
        print(e.toString());
      }
    });

    on<CheckIfAlreadyInCartRequested>((event, emit) async {
      try {
        emit(CartLoading());
        CartProduct? cartProduct = await cartRepository.isAlreadyInCart(
          productId: event.productId,
        );
        if (cartProduct != null) {
          emit(AddToCartSuccessful(quantity: cartProduct.quantity));
        } else {
          emit(CartInitial());
        }
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in AddToCartRequested');
        print(e.toString());
      }
    });

    on<UpdateCartQuantityRequested>((event, emit) async {
      try {
        emit(CartQuantityLoading());
        if (event.currentQuantity == 1 &&
            event.type == UpdateCartQuantityType.decrement) {
          await cartRepository.removeFromCart(
            productId: event.productId,
          );
          // emit(CartInitial());
          emit(CartProductDeleted());
          // emit(CartUpdated());
          return;
        } else {
          CartProduct? cartProduct = await cartRepository.updateCartQuantity(
            productId: event.productId,
            currentQuantity: event.currentQuantity,
            type: event.type,
          );
          if (cartProduct != null) {
            // emit(AddToCartSuccessful(quantity: cartProduct.quantity));
            emit(CartUpdated(quantity: cartProduct.quantity));
          } else {
            emit(CartInitial());
            // emit(CartUpdated());
          }
        }
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in AddToCartRequested');
        print(e.toString());
      }
    });
  }
}
