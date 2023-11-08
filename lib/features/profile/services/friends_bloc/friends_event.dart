import 'dart:typed_data';

import 'package:equatable/equatable.dart';

// @immutable
// sealed class WeatherEvent {}

abstract class FriendsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FriendsDataRequested extends FriendsEvent {
  FriendsDataRequested();
}

// ignore: must_be_immutable
// class ProfileImageUpdateRequested extends FriendsEvent {
//   Uint8List file;
//   ProfileImageUpdateRequested({
//     required this.file,
//   });
// }
