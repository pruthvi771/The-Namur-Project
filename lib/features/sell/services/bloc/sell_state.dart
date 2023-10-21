part of 'sell_bloc.dart';

sealed class SellState extends Equatable {
  const SellState();
  
  @override
  List<Object> get props => [];
}

final class SellInitial extends SellState {}
