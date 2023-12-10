import 'dart:typed_data';

import 'package:equatable/equatable.dart';

// @immutable
// sealed class WeatherEvent {}

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileDataRequested extends ProfileEvent {
  ProfileDataRequested();
}

// ignore: must_be_immutable
class ProfileImageUpdateRequested extends ProfileEvent {
  Uint8List file;
  ProfileImageUpdateRequested({
    required this.file,
  });
}

// ignore: must_be_immutable
class UserNameUpdateRequested extends ProfileEvent {
  String name;
  UserNameUpdateRequested({
    required this.name,
  });
}
