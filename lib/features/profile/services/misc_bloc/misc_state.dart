part of 'misc_bloc.dart';

sealed class MiscState extends Equatable {
  const MiscState();

  @override
  List<Object> get props => [];
}

final class MiscInitial extends MiscState {}

final class MiscLoading extends MiscState {}

final class MiscDataReceived extends MiscState {
  final int numberOfFriends;
  final int numberOfCrops;
  final String villageName;
  final String pincode;

  const MiscDataReceived({
    required this.numberOfFriends,
    required this.numberOfCrops,
    required this.villageName,
    required this.pincode,
  });

  @override
  List<Object> get props => [
        numberOfFriends,
        numberOfCrops,
      ];
}

final class MiscError extends MiscState {}
