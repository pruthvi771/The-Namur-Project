import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_state.dart';
import 'package:active_ecommerce_flutter/features/weather/weather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherSectionBloc
    extends Bloc<WeatherSectionEvent, WeatherSectionState> {
  WeatherSectionBloc() : super(WeatherSectionDataNotReceived()) {
    on<WeatherSectionDataRequested>((event, emit) async {
      emit(LoadingSection());
      try {
        final currentData = await WeatherRepository().fetchCurrent();
        if (currentData == null) {
          emit(LocationDataNotFoundinHive());
          return;
        }
        // await Future.delayed(Duration(seconds: 3));
        emit(WeatherSectionDataReceived(responseData: currentData as dynamic));
        // });
      } catch (e) {
        // print(e);
        final errorMessage = e.toString().replaceAll('Exception:', '');
        print('error message: $errorMessage');
        emit(Error(e.toString()));
      }
    });
  }
}
