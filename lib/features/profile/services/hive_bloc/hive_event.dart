import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class SyncHiveToFirestoreRequested extends HiveEvent {
  final ProfileData profileData;

  SyncHiveToFirestoreRequested({
    required this.profileData,
  });
}

class HiveAppendAddress extends HiveEvent {
  final BuildContext context;
  HiveAppendAddress({
    required this.context,
  });
}
