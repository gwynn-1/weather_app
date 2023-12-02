abstract class WeatherRepository {
  Future getWeather(
    Map<String, dynamic> request,
  );

  Future getLocation(
    String city
  );
}