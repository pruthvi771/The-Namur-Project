// part of 'weather_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// @immutable
// sealed class WeatherEvent {}

abstract class HiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HiveDataRequested extends HiveEvent {
  HiveDataRequested();
}

class HiveLocationDataRequested extends HiveEvent {
  HiveLocationDataRequested();
}

class HiveAppendAddress extends HiveEvent {
  final BuildContext context;
  HiveAppendAddress({
    required this.context,
  });
}
