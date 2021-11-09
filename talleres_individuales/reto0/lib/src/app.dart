import 'package:flutter/material.dart';
import 'package:taller1/src/pages/contador_page.dart';

import 'package:taller1/src/pages/home_page.dart';
import '';

class MyApp extends StatelessWidget{

  @override
  Widget build( context ) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        //child: HomePage(),
        child: ContadorPage()
      ),
    );

  }

}