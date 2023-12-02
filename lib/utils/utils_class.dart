import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class Utils {
  static Widget mapWeatherConditionToImage(
      WeatherCondition condition) {
    Image image;
    switch (condition) {
      case WeatherCondition.thunderstorm:
      case WeatherCondition.rain:
        image = Image.asset('assets/icons/storm_rain.png');
        break;
      
      case WeatherCondition.lightCloud:
         image = Image.asset('assets/icons/light_cloud.png');
        break;
        case WeatherCondition.heavyCloud:
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
        case WeatherCondition.fog:
        case WeatherCondition.atmosphere:
        image = Image.asset('assets/icons/clouds.png');
        break;
      case WeatherCondition.clear:
        image = Image.asset('assets/icons/sun.png');
        break;
      
      case WeatherCondition.snow:
        image = Image.asset('assets/icons/snow.png');
        break;

      default:
        image = Image.asset('assets/images/sun.png');
    }
    return image;
  }

  static Color mapWeatherConditionToColor(
      WeatherCondition condition) {
    Color color;
    switch (condition) {
      case WeatherCondition.thunderstorm:
      case WeatherCondition.rain:
        color = Colors.blue.shade900;
        break;
      
      case WeatherCondition.lightCloud:
         color = Colors.blue;
        break;
        case WeatherCondition.heavyCloud:
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
        case WeatherCondition.fog:
        case WeatherCondition.atmosphere:
        color = Colors.blueGrey;
        break;
      case WeatherCondition.clear:
        color = Colors.orange;
        break;
      
      case WeatherCondition.snow:
        color = Colors.cyan;
        break;

      default:
        color = Colors.blue;
    }
    return color;
  }
}
