import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {}

final class ProfileDataReceived extends ProfileState {
  final BuyerData buyerProfileData;

  ProfileDataReceived({
    required this.buyerProfileData,
  });

  @override
  List<Object?> get props => [buyerProfileData];
}

final class ProfileDataNotReceived extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ProfileImageUpdated extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class Loading extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class Error extends ProfileState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
