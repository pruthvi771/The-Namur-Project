import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherSreenDataRequested extends WeatherEvent {
  WeatherSreenDataRequested();
}
