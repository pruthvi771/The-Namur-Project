import 'package:active_ecommerce_flutter/features/weather/models/current_data.dart';
import 'package:equatable/equatable.dart';

// @immutable
// sealed class WeatherSectionState {}

// final class WeatherSectionInitial extends WeatherSectionState {}

abstract class WeatherSectionState extends Equatable {}

final class WeatherSectionDataReceived extends WeatherSectionState {
  final CurrentWeatherResponse responseData;

  WeatherSectionDataReceived({
    required this.responseData,
  });

  @override
  List<Object?> get props => [responseData];
}

final class WeatherSectionDataNotReceived extends WeatherSectionState {
  @override
  List<Object?> get props => [];
}

final class LoadingSection extends WeatherSectionState {
  @override
  List<Object?> get props => [];
}

final class Error extends WeatherSectionState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
