import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_repository.dart';
import 'package:bloc/bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository checkoutRepository;
  final CartRepository cartRepository;

  CheckoutBloc({
    required this.checkoutRepository,
    required this.cartRepository,
  }) : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CheckoutRequested>((event, emit) async {
      try {
        emit(CheckoutLoading());
        var userCartDocument = await checkoutRepository.getCartDocumenyByUserId(
            userID: event.userID);
        print(userCartDocument);
        await Future.delayed(Duration(seconds: 2));
        List<OrderItem> orderItems = [];
        for (var product in userCartDocument!['products']) {
          var userCartDocument =
              await checkoutRepository.getProductDocumenyByProductId(
            productID: product['productId'],
          );
          print(userCartDocument);
          orderItems.add(
            OrderItem(
              productID: product['productId'],
              quantity: product['quantity'],
              price: userCartDocument!['price'],
              sellerID: userCartDocument['sellerId'],
            ),
          );
        }
        String? orderID =
            await checkoutRepository.createOrder(event.userID, orderItems);
        await cartRepository.clearCart();
        emit(CheckoutCompleted(orderId: orderID!));
      } catch (e) {
        print('error happened in AddToCartRequested');
        print(e.toString());
      }
    });
  }
}
