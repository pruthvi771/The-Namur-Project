import 'package:equatable/equatable.dart';

abstract class FriendsState extends Equatable {}

final class Loading extends FriendsState {
  @override
  List<Object?> get props => [];
}

final class Error extends FriendsState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
