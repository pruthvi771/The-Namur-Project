import 'package:equatable/equatable.dart';

abstract class WeatherSectionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherSectionDataRequested extends WeatherSectionEvent {
  WeatherSectionDataRequested();
}
