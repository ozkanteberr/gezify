import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/weather/bloc/weather_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';



class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService;

  WeatherBloc({required this.weatherService}) : super(WeatherInitial()) {
    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await weatherService.getWeatherByCity(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Şehir için hava durumu alınamadı: ${e.toString()}'));
      }
    });

    on<FetchWeatherByLocation>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await weatherService.getWeatherByLocation(event.latitude, event.longitude);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Konumdan hava durumu alınamadı: ${e.toString()}'));
      }
    });
  }
}
