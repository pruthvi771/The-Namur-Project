import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TranslationState extends Equatable {}

final class TranslationDataReceived extends TranslationState {
  final Locale locale;

  TranslationDataReceived({
    required this.locale,
  });

  @override
  List<Object?> get props => [locale];
}

final class Loading extends TranslationState {
  @override
  List<Object?> get props => [];
}
