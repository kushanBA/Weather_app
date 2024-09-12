import 'package:flutter/material.dart';
import 'package:weath_app/screens/weath_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Weather app",
        home: WeathPage(),
      ),
    );
  }
}
