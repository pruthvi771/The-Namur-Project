import 'package:active_ecommerce_flutter/features/weather/models/forecast_data.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {}

final class Loading extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class WeatherSreenDataReceived extends WeatherState {
  final List<ForecastWeatherResponse?> responseData;

  WeatherSreenDataReceived({
    required this.responseData,
  });

  @override
  List<Object?> get props => [responseData];
}

final class WeatherScreenDataNotReceived extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class ScreenNoLocationDataFound extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class Error extends WeatherState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
