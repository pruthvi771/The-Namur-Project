import 'package:equatable/equatable.dart';

abstract class RentState extends Equatable {
  const RentState();

  @override
  List<Object> get props => [];
}

final class RentInitial extends RentState {}

final class RentSuccess extends RentState {
  final String documentId;

  const RentSuccess({
    required this.documentId,
  });

  @override
  List<Object> get props => [documentId];
}

final class RentLoading extends RentState {
  const RentLoading();

  @override
  List<Object> get props => [];
}

final class RentError extends RentState {
  final String message;

  const RentError({required this.message});

  @override
  List<Object> get props => [message];
}
