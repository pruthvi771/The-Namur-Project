import 'dart:typed_data';

import 'package:equatable/equatable.dart';

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

class UserNameUpdateRequested extends ProfileEvent {
  String name;
  UserNameUpdateRequested({
    required this.name,
  });
}
