class Weath {
  late final String cityName;
  late final String temperature;
  late final String mainCondition;
  late final String image;
  late final air;

  Weath(
      {required this.cityName,
      required this.temperature,
      required this.mainCondition,
      required this.image,
      required this.air});

  factory Weath.fromJson(Map<String, dynamic> json) {
    return Weath(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'].toString(),
      mainCondition: json['current']['condition']['text'],
      // ignore: prefer_interpolation_to_compose_strings
      image: 'https:' + json['current']['condition']['icon'],
      //usually uses pm10 as air quality
      air: json['current']['air_quality']['us-epa-index'],
    );
  }
}

class HourlyForecast {
  final String time;
  final String temperature;
  final String condition;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      temperature: json['temp_c'].toString(),
      condition: json['condition']['text'],
      icon: 'https:' + json['condition']['icon'],
    );
  }
}

class HourlyForecastData {
  final List<HourlyForecast> hourlyForecasts;

  HourlyForecastData({required this.hourlyForecasts});

  // Method to get the next 24 hours of forecast from the current time
  List<HourlyForecast> getNext24Hours() {
    final now = DateTime.now();
    final next24Hours = now.add(Duration(hours: 24));

    // Filter the hourly forecasts to get the next 24 hours
    return hourlyForecasts
        .where((forecast) {
          final forecastTime = DateTime.parse(forecast.time);
          return forecastTime.isAfter(now) &&
              forecastTime.isBefore(next24Hours);
        })
        .take(24)
        .toList();
  }

  factory HourlyForecastData.fromJson(Map<String, dynamic> json) {
    // Combine forecast data for today and tomorrow
    // because need the next 24 hours
    final List<dynamic> today = json['forecast']['forecastday'][0]['hour'];
    final List<dynamic> tomorrow = json['forecast']['forecastday'][1]['hour'];
    final hourlyForecasts = [...today, ...tomorrow]
        .map((hour) => HourlyForecast.fromJson(hour))
        .toList();

    return HourlyForecastData(hourlyForecasts: hourlyForecasts);
  }
}
