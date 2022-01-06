import 'package:flutter/material.dart';
import 'package:taller8/src/pages/editar.dart';
import 'package:taller8/src/pages/listado.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MiApp(),
    );
  }
}

class MiApp extends StatelessWidget {
  const MiApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/" : (context) => Listado(),
        "/editar": (context) => Editar()
      }
    );
  }
}