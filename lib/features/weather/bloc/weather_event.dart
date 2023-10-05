// part of 'weather_bloc.dart';
import 'package:equatable/equatable.dart';

// @immutable
// sealed class WeatherEvent {}

abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// class WeatherSectionInfoRequested extends WeatherEvent {
//   WeatherSectionInfoRequested();
// }

class WeatherSreenDataRequested extends WeatherEvent {
  WeatherSreenDataRequested();
}
