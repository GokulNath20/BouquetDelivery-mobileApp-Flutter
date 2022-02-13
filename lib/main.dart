import 'package:flutter/material.dart';
import 'package:project_bouquet_delivery/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData.dark(),
        title: 'Bouquet Delivery Sepang',
        home: const Scaffold(
          body: SplashPage(),
        ));
  }
}
