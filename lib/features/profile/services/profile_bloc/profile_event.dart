import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// @immutable
// sealed class WeatherEvent {}

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileDataRequested extends ProfileEvent {
  ProfileDataRequested();
}

class ProfileImageUpdateRequested extends ProfileEvent {
  Uint8List file;
  ProfileImageUpdateRequested({
    required this.file,
  });
}

class TotalPincodeFriendsCountRequested extends ProfileEvent {
  String pincode;

  TotalPincodeFriendsCountRequested({
    required this.pincode,
  });
}
