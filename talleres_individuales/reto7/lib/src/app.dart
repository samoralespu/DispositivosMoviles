import 'package:flutter/material.dart';
import 'package:reto3/src/pages/tricky_game.dart';
import 'package:reto3/src/pages/tricky_online.dart';

class MyApp extends StatelessWidget {
  static const String title = 'Tricky en flutter';
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Center(
          child: TickyOnlinePage(
        title: "Tricky en flutter",
      )
          //MyHomePage( title: "Tricky en flutter",)
          ),
    );
  }
}
