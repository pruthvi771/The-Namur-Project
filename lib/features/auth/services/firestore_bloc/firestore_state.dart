import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FirestoreState extends Equatable {}
//   final String? verificationId;

//   FirestoreState({this.verificationId});
// }

class Loading extends FirestoreState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class Success extends FirestoreState {
  @override
  List<Object?> get props => [];
}

class FirestoreError extends FirestoreState {
  final String error;

  FirestoreError(this.error);
  @override
  List<Object?> get props => [error];
}
