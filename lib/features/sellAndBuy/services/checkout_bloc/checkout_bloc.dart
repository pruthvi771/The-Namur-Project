import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_state.dart';
import 'package:bloc/bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });

    // on<AddToCartRequested>((event, emit) async {
    //   try {
    //     emit(CartLoading());
    //     await cartRepository.addToCart(
    //       productId: event.productId,
    //       quantity: 1,
    //     );
    //     emit(AddToCartSuccessful(quantity: 1));
    //   } catch (e) {
    //     // emit(SellAddProductErrorState(message: e.toString()));
    //     print('error happened in AddToCartRequested');
    //     print(e.toString());
    //   }
    // });
  }
}
