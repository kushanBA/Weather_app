import 'package:flutter/material.dart';
import 'package:weath_app/models/weath_model.dart';
import 'package:weath_app/services/weath_services.dart';

// ignore: must_be_immutable
class ForecastPage extends StatefulWidget {
  ForecastPage({super.key, required this.cityName});
  String cityName;

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final _weathService = WeathServices();
  HourlyForecastData? _hourlyForecastData;

  _fetchWeath(city) async {
    try {
      final hourlyForecastData = await _weathService.getHourlyForecast(city);
      setState(() {
        _hourlyForecastData = hourlyForecastData;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeath(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      body: Center(
        child: _hourlyForecastData == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _hourlyForecastData!
                          .getNext24Hours()
                          .length, // Now there will be 24 items
                      itemBuilder: (context, index) {
                        final forecast =
                            _hourlyForecastData!.getNext24Hours()[index];
                        String datetime = (forecast.time);
                        List<String> hoursMinutes = datetime.split(" ");
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: const Color.fromARGB(103, 154, 177, 189),
                            leading: Image.network(forecast.icon),
                            title: Text(
                                '${hoursMinutes[1]}  ${forecast.temperature}°C'),
                            subtitle: Text(forecast.condition),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ),
      ),
    );
  }
}
