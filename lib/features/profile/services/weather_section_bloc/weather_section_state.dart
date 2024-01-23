import 'package:active_ecommerce_flutter/features/weather/models/current_data.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherSectionState extends Equatable {}

final class WeatherSectionDataReceived extends WeatherSectionState {
  final List<CurrentWeatherResponse?> responseData;

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

final class LocationDataNotFoundinHive extends WeatherSectionState {
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
