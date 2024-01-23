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
    on<CheckoutEvent>((event, emit) {});

    on<CheckoutInitialEventRequested>((event, emit) {
      emit(CheckoutInitial());
    });

    on<CheckoutRequested>((event, emit) async {
      try {
        emit(CheckoutLoading());
        var userCartDocument = await checkoutRepository.getCartDocumenyByUserId(
            userID: event.userID);

        await Future.delayed(Duration(seconds: 2));
        List<OrderItem> orderItems = [];
        for (var product in userCartDocument!['products']) {
          var userCartDocument =
              await checkoutRepository.getProductDocumenyByProductId(
            productID: product['productId'],
          );

          var response = await checkoutRepository.canReduceProductQuantity(
              productId: product['productId'],
              quantityToReduce: product['quantity']);

          if (response[0] == false) {
            emit(
              NotEnoughQuantityError(
                productName: userCartDocument!['name'],
                availableQuantity: response[1],
              ),
            );
            return;
          } else if (response[0] == ReduceQuantityResponseEnum.Error) {
            emit(CheckoutError(
                message: 'Something went wrong. Please try again.'));
            return;
          }
          // orderItems.add(
          //   OrderItem(
          //     productID: product['productId'],
          //     name: userCartDocument!['name'],
          //     quantity: product['quantity'],
          //     price: userCartDocument['price'],
          //     sellerID: userCartDocument['sellerId'],
          //     rating: null,
          //   ),
          // );
        }
        // String? orderID =
        //     await checkoutRepository.createOrder(event.userID, orderItems);
        // await cartRepository.clearCart();
        emit(CheckoutApproved());
      } catch (e) {}
    });

    on<CreateOrderRequested>((event, emit) async {
      try {
        emit(CheckoutLoading());
        var userCartDocument = await checkoutRepository.getCartDocumenyByUserId(
            userID: event.userID);

        await Future.delayed(Duration(seconds: 2));
        List<OrderItem> orderItems = [];
        for (var product in userCartDocument!['products']) {
          var userCartDocument =
              await checkoutRepository.getProductDocumenyByProductId(
            productID: product['productId'],
          );

          var response = await checkoutRepository.reduceProductQuantity(
              productId: product['productId'],
              quantityToReduce: product['quantity']);

          if (response[0] == false) {
            emit(
              NotEnoughQuantityError(
                productName: userCartDocument!['name'],
                availableQuantity: response[1],
              ),
            );
            return;
          } else if (response[0] == ReduceQuantityResponseEnum.Error) {
            emit(CheckoutError(
                message: 'Something went wrong. Please try again.'));
            return;
          }
          orderItems.add(
            OrderItem(
              productID: product['productId'],
              name: userCartDocument!['name'],
              quantity: product['quantity'],
              price: userCartDocument['price'],
              sellerID: userCartDocument['sellerId'],
              rating: null,
            ),
          );
        }
        String? orderID = await checkoutRepository.createOrder(
            event.userID, orderItems, event.address);
        await cartRepository.clearCart();
        emit(CheckoutCompleted(orderId: orderID!));
      } catch (e) {}
    });
  }
}
