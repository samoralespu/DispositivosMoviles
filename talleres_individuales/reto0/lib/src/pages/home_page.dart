import 'package:flutter/material.dart';


class HomePage extends StatelessWidget{

  final estiloTexto = new TextStyle(fontSize: 32);
  final cont = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Titulo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hola mundo', style: estiloTexto),
            Text('$cont', style: estiloTexto),
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_sharp),
        onPressed: () {
          //cont = cont + 1 ;
        },

      ),
    );
  }

}