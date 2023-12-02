import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/repositories/weather_repository_impl.dart';
import 'package:weather_app/service/api_services/models/dio_model.dart';
import 'package:weather_app/utils/string_extension.dart';

enum ResultState { initial, loading, success, error }

final WeatherRepository weatherRepo = WeatherRepositoryImpl();

final searchControlerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());

final weatherProvider = StateProvider<Forecast?>((ref) => null);
final resultStateProvider =
    StateProvider<ResultState>((ref) => ResultState.initial);

final getWeatherInfoProvider =
    FutureProvider.autoDispose.family((ref, String city) async {
  Location? location;

  DioResponse resp = await weatherRepo.getLocation(city);
  resp.maybeWhen(
    success: (data) {
      location = Location.fromJson(data);
    },
    error: (data) {
      ref
          .read(resultStateProvider.notifier)
          .update((state) => ResultState.error);
      debugPrint("error message" + data.toString());
    },
    orElse: () {
      ref
          .read(resultStateProvider.notifier)
          .update((state) => ResultState.initial);
      location = null;
    },
  );

  if (location != null) {
    DioResponse weatherResp = await weatherRepo.getWeather({
      "lat": location!.latitude,
      "lon": location!.longitude,
      "exclude": "hourly,minutely",
      "units":"metric"
    });
    weatherResp.maybeWhen(
      success: (data) {
        ref
            .read(resultStateProvider.notifier)
            .update((state) => ResultState.success);
        Forecast fc = Forecast.fromJson(data);
        fc.city = city.toCapitalized();
        ref.read(weatherProvider.notifier).update((state) => fc);
      },
      error: (data) {
        ref
            .read(resultStateProvider.notifier)
            .update((state) => ResultState.error);
      },
      orElse: () {
        ref
            .read(resultStateProvider.notifier)
            .update((state) => ResultState.initial);
        location = null;
      },
    );
  }
});
