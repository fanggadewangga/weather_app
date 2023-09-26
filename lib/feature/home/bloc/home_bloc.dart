import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/data/constants.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(HomeLoading());
      try {
        var key = dotenv.env[apiKey];
        if (key != null) {
          WeatherFactory weatherFactory =
              WeatherFactory(key, language: Language.INDONESIAN);
          Weather weather = await weatherFactory.currentWeatherByLocation(
              event.position.latitude, event.position.longitude);
          emit(HomeSuccess(weather));
        } else {
          emit(HomeFailure());
        }
      } catch (e) {
        emit(HomeFailure());
      }
    });
  }
}
