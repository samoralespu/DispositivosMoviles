import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: title),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Utils {
  static List<Widget> modelBuilder<M>(
      List<M> models, Widget Function(int index, M model) builder) =>
      models.asMap().map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model))
      ).values.toList();
}

class Player {
  static const openSpot = '';
  static const humanPlayer = 'X';
  static const computerPlayer = 'O';
}

class Coordinates {
  final int x;
  final int y;

  Coordinates(this.x, this.y);
}

class _MyHomePageState extends State<MyHomePage> {
  static const countMatrix = 3;
  static const double size = 120;
  String lastMove = Player.openSpot;
  late List<List<String>> matrix;

  @override
  void initState() {
    super.initState();
    setEmptyFields();
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
    countMatrix, (_) => List.generate(countMatrix, (_) => Player.openSpot),
  ));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey,
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
    ),
  );

  Widget buildRow(int x) {
    final values = matrix[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values, (y, value) => buildField(x, y),
      ),
    );
  }

  Widget buildField(int x, int y) {
    final value = matrix[x][y];

    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(size, size),
          primary: Colors.white,
        ),
        child: Text(value, style: const TextStyle(fontSize: 32, color: Colors.black)),
        onPressed: (){
          if (value == Player.openSpot && (lastMove == Player.computerPlayer || lastMove == Player.openSpot)) {
            selectField(value, x, y);
          }
        },
      ),
    );
  }

  void selectField(String value, int x, int y) {
      const newValue = Player.humanPlayer;

      setState(() {
        lastMove = newValue;
        matrix[x][y] = newValue;
      });

      if (isWinner(x, y, "X")) {
        lastMove = Player.openSpot;
        showEndDialog('Gana el jugador');
        return ;
      } else if (isEnd()) {
        lastMove = Player.openSpot;
        showEndDialog('Empate');
        return ;
      }

      final temp = getComputerMove();

      x = temp.x;
      y = temp.y;

      if (isWinner(x, y, "O")) {
        lastMove = Player.openSpot;
        showEndDialog('Gana la máquina');
      } else if (isEnd()) {
        lastMove = Player.openSpot;
        showEndDialog('Empate');
      }
  }

  bool isEnd() => matrix.every((values) => values.every((value) => value != Player.openSpot));

  Coordinates getComputerMove() {
    const newValue = Player.computerPlayer;
    const n = countMatrix;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if ((matrix[i][j] == Player.openSpot) && willWin(i, j, "O") && lastMove == Player.humanPlayer) {
          setState(() {
            lastMove = newValue;
            matrix[i][j] = newValue;
          });
          return Coordinates(i,j);
        }
      }
    }
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if ((matrix[i][j] == Player.openSpot) && willWin(i, j, "X") && lastMove == Player.humanPlayer) {
          setState(() {
            lastMove = newValue;
            matrix[i][j] = newValue;
          });
          return Coordinates(i,j);
        }
      }
    }

    dynamic xr;
    dynamic xy;
    var ranX = new Random();
    var ranY = new Random();
    xr = ranX.nextInt(3);
    xy = ranY.nextInt(3);


    while (matrix[xr][xy] != Player.openSpot){
      xr = ranX.nextInt(3);
      xy = ranY.nextInt(3);
    }

    setState(() {
      lastMove = newValue;
      matrix[xr][xy] = newValue;
    });


    return Coordinates(xr,xy);
  }

  bool willWin(int x, int y, String z) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = z;
    const n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) col++;
      if (matrix[i][y] == player) row++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) rdiag++;
    }

    col++;
    row++;
    if(x == y){
      if(x == 1){
        rdiag++;
      }
      diag++;
    }
    if((x == 0 && y == 2) || (x == 2 && y == 0)){
      rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  bool isWinner(int x, int y, String z) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = z;
    const n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) col++;
      if (matrix[i][y] == player) row++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) rdiag++;
    }
    return row == n || col == n || diag == n || rdiag == n;
  }

  Future showEndDialog(String title) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: const Text('Reiniciar el juego'),
      actions: [
        ElevatedButton(
          onPressed: () {
            setEmptyFields();
            Navigator.of(context).pop();
          },
          child: const Text('Reiniciar'),
        )
      ],
    ),
  );
}




