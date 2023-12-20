import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:equatable/equatable.dart';

abstract class HiveState extends Equatable {}

final class HiveDataReceived extends HiveState {
  final ProfileData profileData;

  HiveDataReceived({
    required this.profileData,
  });

  @override
  List<Object?> get props => [profileData];
}

final class HiveLocationDataReceived extends HiveState {
  final List<String> locationData;

  HiveLocationDataReceived({
    required this.locationData,
  });

  @override
  List<Object?> get props => [locationData];
}

final class HiveDataNotReceived extends HiveState {
  @override
  List<Object?> get props => [];
}

final class HiveDataUpdated extends HiveState {
  @override
  List<Object?> get props => [];
}

final class Loading extends HiveState {
  @override
  List<Object?> get props => [];
}

final class Error extends HiveState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
