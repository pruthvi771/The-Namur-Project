import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
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

// final CurrentWeatherResponse responseData;

// WeatherSectionDataReceived({
//   required this.responseData,
// });

// @override
// List<Object?> get props => [responseData];

final class HiveDataNotReceived extends HiveState {
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
