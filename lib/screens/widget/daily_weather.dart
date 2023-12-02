import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/utils/utils_class.dart';

class DailyWeather extends StatefulWidget {
  final Weather? weather;

  const DailyWeather({super.key, this.weather});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DailyWeather();
  }
}

class _DailyWeather extends State<DailyWeather> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text((widget.weather?.date != null) ? DateFormat("EEEE").format(widget.weather!.date!): "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
              Text((widget.weather?.temp?.toString() ?? "0") + "°C",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ]),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: Container(
                    alignment: Alignment.center,
                    child: Utils.mapWeatherConditionToImage(widget.weather?.condition ?? WeatherCondition.unknown)))
          ],
        ));
  }
}
