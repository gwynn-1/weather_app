import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/service/api_services/api_service.dart';
import 'package:weather_app/service/api_services/models/dio_model.dart';
import 'package:weather_app/utils/url_constants.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  @override
  Future getLocation(String city) async {
    // TODO: implement getLocation
    DioResponse? res = await ApiService().apiCall(UrlConstants.weatherLocation, queryParameters: {
      "q":city
    });

    return res;
  }

  @override
  Future getWeather(Map<String, dynamic> request) async {
    // TODO: implement getWeather
    DioResponse? res = await ApiService().apiCall(UrlConstants.weather, queryParameters: request);

    return res;
  }
}
