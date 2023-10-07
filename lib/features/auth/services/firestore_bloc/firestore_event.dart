import 'package:equatable/equatable.dart';

abstract class FirestoreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddUserToBuyerSellerColections extends FirestoreEvent {
  final String name;
  final String email;
  final String userid;

  AddUserToBuyerSellerColections(this.email, this.name, this.userid);
}
