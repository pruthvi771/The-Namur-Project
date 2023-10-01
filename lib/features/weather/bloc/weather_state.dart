// part of 'weather_bloc.dart';
import 'package:equatable/equatable.dart';
// @immutable
// sealed class WeatherState {}

// final class WeatherInitial extends WeatherState {}

abstract class WeatherState extends Equatable {}

final class WeatherSectionInfoReceived extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class WeatherSectionInfoNotReceived extends WeatherState {
  @override
  List<Object?> get props => [];
}

final class Loading extends WeatherState {
  @override
  List<Object?> get props => [];
}
