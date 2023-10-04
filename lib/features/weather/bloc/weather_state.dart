// part of 'weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/models/current_data.dart';
import 'package:active_ecommerce_flutter/features/weather/models/forecast_data.dart';
import 'package:equatable/equatable.dart';
// @immutable
// sealed class WeatherState {}

// final class WeatherInitial extends WeatherState {}

abstract class WeatherState extends Equatable {}

final class WeatherSectionInfoReceived extends WeatherState {
  final CurrentWeatherResponse responseData;

  WeatherSectionInfoReceived({
    required this.responseData,
  });

  @override
  List<Object?> get props => [responseData];
}

final class WeatherSectionInfoNotReceived extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class Loading extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class WeatherSreenDataReceived extends WeatherState {
  final ForecastWeatherResponse responseData;

  WeatherSreenDataReceived({
    required this.responseData,
  });

  @override
  List<Object?> get props => [responseData];
}

final class Error extends WeatherState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
