import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/utils/translation_bloc/translation_event.dart';
import 'package:active_ecommerce_flutter/utils/translation_bloc/translation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc() : super(Loading()) {
    on<TranslationDataRequested>((event, emit) async {
      // var dataBox = Hive.box<TranslationData>('translationDataBox');

      // var translatinData = TranslationData()..locale = event.locale;
      // await dataBox.put('locale', translatinData);

      emit(TranslationDataReceived(locale: Locale(event.locale)));
    });
  }
}
