import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: MapSample()
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  String dropdownValue = '2020';
  String placeValue = 'BOYACÁ';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _getStats(dropdownValue, placeValue),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    menuMaxHeight: 200,
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 10,),
                  DropdownButton<String>(
                    value: placeValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        placeValue = newValue!;
                      });
                    },
                    items: <String>[ "BOYACÁ", "META", "LA GUAJIRA", "GUAVIARE", "SUCRE", "ARAUCA", "BOLÍVAR", "CÓRDOBA", "VICHADA", "BOGOTÁ D.C.", "CASANARE", "VAUPÉS", "VALLE DEL CAUCA", "CUNDINAMARCA", "MAGDALENA", "HUILA", "NORTE DE SANTANDER", "TOLIMA", "NARIÑO", "AMAZONAS",    
                      ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),


                ],
              ),
              SizedBox(height: 100,),
              Center(child: Text('Tecnica proofesional: ' + snapshot.data[0][11]),),
              SizedBox(height: 10,),
              Center(child: Text('Tecnológica: ' + snapshot.data[0][12]),),
              SizedBox(height: 10,),
              Center(child: Text('Universitaria: ' + snapshot.data[0][13]),),
              SizedBox(height: 10,),
              Center(child: Text('Maestria: ' + snapshot.data[0][14]),),
              SizedBox(height: 10,),
              Center(child: Text('Doctorado: ' + snapshot.data[0][15]),),
            ],
          );
        } else {
          return const Center(child: Text('data'),);
        }
        
      },
    );
  }

  Future<List> _getStats(String year, String department) async {
    Response response = await get(Uri.parse('https://www.datos.gov.co/api/views/4hrb-y62g/rows.json?accessType=DOWNLOAD'));
    Map data = jsonDecode(response.body);
    List results = (data["data"]);
    List matriculasAnio = [];
    for (dynamic place in results) {
      if(place[8] == year && place[10] == department.toUpperCase()) {
        matriculasAnio.add(place);
      }
    }
    return matriculasAnio;
    
  }
}
