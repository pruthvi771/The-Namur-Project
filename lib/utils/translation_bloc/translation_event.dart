import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TranslationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TranslationDataRequested extends TranslationEvent {
  String locale;
  TranslationDataRequested({
    required this.locale,
  });
}
