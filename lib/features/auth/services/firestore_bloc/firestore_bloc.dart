import 'package:active_ecommerce_flutter/features/auth/services/firestore_bloc/firestore_event.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_bloc/firestore_state.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreRepository firestoreRepository;

  FirestoreBloc({required this.firestoreRepository}) : super(Loading()) {
    on<AddUserToBuyerSellerColections>((event, emit) async {
      print('SignInWithEmailRequested started');
      // emit(Loading());

      print("User added to buyer and seller collections ...... ");

      try {
        await firestoreRepository
            .addUserToBuyerSellerCollections(
                userId: event.userid, name: event.name, email: event.email)
            .then((value) {
          print("User added to buyer and seller collections");
        });
      } catch (e) {
        print(e);
        print('error happened');
      }
      print('done adding');
      emit(Success());
    });
  }
}
