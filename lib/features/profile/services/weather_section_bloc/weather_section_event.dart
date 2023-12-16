// part of 'weather_bloc.dart';
import 'package:equatable/equatable.dart';

// @immutable
// sealed class WeatherEvent {}

abstract class WeatherSectionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// class WeatherSectionSectionInfoRequested extends WeatherSectionEvent {
//   WeatherSectionSectionInfoRequested();
// }

class WeatherSectionDataRequested extends WeatherSectionEvent {
  WeatherSectionDataRequested();
}
