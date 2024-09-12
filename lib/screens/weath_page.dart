import 'package:flutter/material.dart';
import 'package:weath_app/models/weath_model.dart';
import 'package:weath_app/screens/forecast_page.dart';
import 'package:weath_app/services/weath_services.dart';

class WeathPage extends StatefulWidget {
  const WeathPage({super.key});

  @override
  State<WeathPage> createState() => _WeathPageState();
}

class _WeathPageState extends State<WeathPage> {
  final _weathService = WeathServices();
  Weath? _weath;
  final TextEditingController _cityController = TextEditingController();
  _fetchWeath(city) async {
    try {
      final weath = await _weathService.getCurrentWeath(city);
      setState(() {
        _weath = weath;
      });
    } catch (e) {
      print(e);
    }
  }

  String airQuality(us_epa) {
    final str_air = us_epa.toString();
    final double_air = double.parse(str_air);
    if (double_air <= 50) {
      return ("Good");
    } else if (double_air <= 100) {
      return ("Moderate");
    } else if (double_air <= 200) {
      return ("Unhealthy");
    } else {
      return ("Very Unhealthy");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeath("Kandy");
  }

  //get the time
  final String hour = (DateTime.now()).hour.toString();
  final String min = (DateTime.now()).minute.toString();

  //Icons
  final air_icon = const Icon(Icons.air);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: _weath == null
                ? CircularProgressIndicator()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 216, 189, 108)),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                          autofocus: false,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              hintText: "Enter City Name..",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(179, 127, 131, 127))),
                          controller: _cityController,
                          onSubmitted: (val) {
                            _fetchWeath(val);
                          },
                        ),
                      ),
                      SizedBox(height: 70),
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              height: 500,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 95, 102, 141),
                              ),
                            ),
                          ),
                          Container(
                            height: 500,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _weath!.cityName,
                                  style: TextStyle(fontSize: 28),
                                ),
                                Text(
                                  '$hour : $min',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 25, 39, 37),
                                      fontWeight: FontWeight.bold),
                                ),
                                Image.network(
                                  _weath!.image,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                Text(_weath!.temperature.toString() + '°C'),
                                Text(_weath!.mainCondition),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    child: Text(
                                      'Air Quality - ${airQuality(_weath!.air)}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto', fontSize: 15),
                                    )),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return ForecastPage(
                                              cityName: _cityController.text);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("24Hours Forecast"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
                  )),
      ),
    );
  }
}
