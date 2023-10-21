import 'dart:typed_data';

import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sell/services/sell_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sell_event.dart';
part 'sell_state.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final AuthRepository authRepository;
  final SellRepository sellRepository;

  SellBloc({required this.authRepository, required this.sellRepository})
      : super(SellInitial()) {
    on<SellEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SellAddProductEvent>((event, emit) async {
      var currentUser = authRepository.currentUser!;

      try {
        var docId = await sellRepository.addProductBuying(
          productName: event.productName,
          productDescription: event.productDescription,
          productPrice: event.productPrice,
          priceType: event.priceType,
          category: event.category,
          subCategory: event.subCategory,
          subSubCategory: event.subSubCategory,
          imageURL: "",
          userId: currentUser.userId,
        );

        await sellRepository.saveProductImage(file: event.image, docId: docId!);

        // emit(SellAddProductSuccessState());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened');
      }
    });
  }
}
