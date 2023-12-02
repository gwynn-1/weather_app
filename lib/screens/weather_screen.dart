import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/weather_provider.dart';
import 'package:weather_app/screens/widget/daily_weather.dart';
import 'package:weather_app/utils/string_extension.dart';
import 'package:weather_app/screens/widget/search_input.dart';
import 'package:weather_app/utils/utils_class.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _WeatherScreen();
  }
}

class _WeatherScreen extends ConsumerState<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    ResultState searchState = ref.watch(resultStateProvider);
    Forecast? fc = ref.watch(weatherProvider);
    // TODO: implement build
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: Utils.mapWeatherConditionToColor(
              fc?.current?.condition ?? WeatherCondition.unknown)),
      child: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SearchInput(
              searchController: ref.read(searchControlerProvider),
              onSearch: (String city) {
                ref
                    .read(resultStateProvider.notifier)
                    .update((state) => ResultState.loading);
                ref.read(getWeatherInfoProvider(city));
              },
            ),
            SizedBox(height: 25),
            if (searchState == ResultState.success) ..._buildWeather(fc),
            if (searchState == ResultState.error) _emptyData(),
            if (searchState == ResultState.loading)
              CircularProgressIndicator(
                color: Colors.white,
              )
          ],
        ),
      ),
    ));
  }

  Widget _emptyData() {
    return Text(
      "Can't find any data",
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  List<Widget> _buildWeather(Forecast? fc) {
    return [
      Text(
        fc?.city ?? "",
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
      SizedBox(height: 50),
      Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text((fc?.current?.temp.toString() ?? "0") + "°C",
                  style: TextStyle(fontSize: 40, color: Colors.white)),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Feels like: ${fc?.current?.feelLikeTemp.toString() ?? "0"}°C",
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ],
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Utils.mapWeatherConditionToImage(
                fc?.current?.condition ?? WeatherCondition.unknown),
          ))
        ],
      ),
      SizedBox(height: 50),
      Expanded(
        child: Text(
          fc?.current?.description?.toTitleCase() ?? "",
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
      Container(
          height: 100,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: (fc?.daily ?? [])
                  .map((item) => DailyWeather(
                        weather: item,
                      ))
                  .toList())),
    ];
  }
}
