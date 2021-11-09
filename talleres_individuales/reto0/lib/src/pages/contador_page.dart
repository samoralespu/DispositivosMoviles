import 'package:flutter/material.dart';

class ContadorPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ContadorPageState();
  }

}

class _ContadorPageState extends State<ContadorPage> {

  final _estiloTexto = new TextStyle(fontSize: 32);
  int _cont = 0;

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
              Text('Contador', style: _estiloTexto),
              Text('$_cont', style: _estiloTexto),
            ],
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _crearBotones()
    );
  }

  Widget _crearBotones(){

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox( width: 10),
        FloatingActionButton(onPressed: _reset, child: Icon(Icons.exposure_zero )),
        Expanded(child: SizedBox()) ,
        FloatingActionButton(onPressed: _remove, child: Icon(Icons.remove )),
        SizedBox( width: 10),
        FloatingActionButton(onPressed: _add, child: Icon(Icons.add )),
        SizedBox( width: 10),
      ],
    );
  }

  void _add() {
    setState(() => _cont++);
  }

  void _remove() {
    setState(() => _cont--);
  }

  void _reset(){
    setState(() => _cont = 0);
  }

}