import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

abstract class _Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
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
  int playerScore = 0;
  int computerScore = 0;
  int tiesScore = 0;
  String winnerTextString = "";
  String lastMove = Player.openSpot;
  List<List<String>> matrix = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""]
  ];
  bool _btnEnabled = true;
  List<String> difficultyLevel = ["Easy", "Harder", "Expert"];
  String mDifficultyLevel = "Easy";
  late final AudioCache _audioCache;

  @override
  void initState() {
    getPlayerScore();
    getComputerScore();
    getlastMove();
    getBtnEnabled();
    getWinnerTextString();
    getMatrix();
    getTiesScore();
    //setEmptyFields();
    //setWinnerTextString(getWinnerTextString());
    super.initState();
    _audioCache = AudioCache(
      prefix: 'assets/audio/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  Future<int> getPlayerScore() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final playerScore1 = pref.getInt('playerScore');

    if (playerScore1 == null) {
      setState(() => playerScore = 0);
      return 1;
    }
    setState(() => playerScore = playerScore1);
    return playerScore1;
  }

  Future<void> setPlayerScore(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('playerScore', prefValue);
  }

  Future<int> getComputerScore() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final computerScore1 = pref.getInt('computerScore');

    if (computerScore1 == null) {
      setState(() => computerScore = 0);
      return 1;
    }
    setState(() => computerScore = computerScore1);
    return computerScore1;
  }

  Future<void> setComputerScore(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('computerScore', prefValue);
  }

  Future<int> getTiesScore() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final tiesScore1 = pref.getInt('tiesScore');

    if (tiesScore1 == null) {
      setState(() => tiesScore = 0);
      return 1;
    }
    setState(() => tiesScore = tiesScore1);
    return tiesScore1;
  }

  Future<void> setTiesScore(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('tiesScore', prefValue);
  }

  Future<String> getWinnerTextString() async {
    final pref = await SharedPreferences.getInstance();
    final winnerTextString1 = pref.getString('winnerTextString');

    if (winnerTextString1 == null) {
      setState(() => winnerTextString = '');
      return '';
    }
    setState(() => winnerTextString = winnerTextString1);
    return winnerTextString1;
  }

  Future<void> setWinnerTextString(prefValue) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('winnerTextString', prefValue);
    print("new winnerTextString :" + prefValue);
    getMatrix();
  }

  Future<String> getlastMove() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final lastMove1 = pref.getString('lastMove');

    if (lastMove1 == null) {
      setState(() => lastMove = '');
      return '';
    }
    setState(() => lastMove = lastMove1);
    return lastMove1;
  }

  Future<void> setlastMove(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('lastMove', prefValue);
  }

  Future<List<String>> getMatrix() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final matrix0 = pref.getStringList('matrix0');
    final matrix1 = pref.getStringList('matrix1');
    final matrix2 = pref.getStringList('matrix2');
    if (matrix0 == null || matrix1 == null || matrix2 == null) {
      setState() {
        matrix[0] = ['', '', ''];
        matrix[1] = ['', '', ''];
        matrix[2] = ['', '', ''];
      }

      return [];
    }
    matrix[0] = matrix0;
    matrix[1] = matrix1;
    matrix[2] = matrix2;

    return matrix1;
  }

  Future<void> setMatrix0(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('matrix0', prefValue);
    print("new MATRIX0 :" + prefValue.toString());
  }

  Future<void> setMatrix1(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('matrix1', prefValue);
    print("new MATRIX1 :" + prefValue.toString());
  }

  Future<void> setMatrix2(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('matrix2', prefValue);
    print("new MATRIX2 :" + prefValue.toString());
  }

  Future<bool> getBtnEnabled() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final btnEnabled1 = pref.getBool('BtnEnabled');

    if (btnEnabled1 == null) {
      setState(() => _btnEnabled = true);
      return true;
    }
    setState(() => _btnEnabled = btnEnabled1);
    return btnEnabled1;
  }

  Future<void> setBtnEnabled(prefValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('BtnEnabled', prefValue);
  }

  void setEmptyFields() {
    List<String> emptyList = ['', '', ''];
    setState(() {
      setMatrix0(emptyList);
      setMatrix1(emptyList);
      setMatrix2(emptyList);
      matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => Player.openSpot),
      );
    });
    setBtnEnabled(true);
    _btnEnabled = true;
    setlastMove("O");
    lastMove = "O";
  }

  Color getFieldColor(String value) {
    switch (value) {
      case Player.computerPlayer:
        return Colors.blue;
      case Player.humanPlayer:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  /*void setButtonDisabled() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => Player.openSpot),
      ));*/

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    if (mediaQueryData.orientation == Orientation.landscape) {
      return _returnScaffold(true);
    } else {
      return _returnScaffold(false);
    }
  }

  Widget _returnScaffold(bool isLandscape) {
    if (isLandscape) {
      return Scaffold(
        backgroundColor: Colors.blue.withAlpha(150),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: landscapeOrientation(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.blue.withAlpha(150),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: portraitOrientation(),
        ),
        bottomNavigationBar: _bottomButtons(isLandscape),
      );
    }
  }

  Widget portraitOrientation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        boardGame(1.9),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Wins: $playerScore "),
              Text("Losses: $computerScore "),
              Text("Ties: $tiesScore "),
            ],
          ),
        ),
        if (!_btnEnabled) winnerText(),
      ],
    );
  }

  Widget landscapeOrientation() {
    double c_width = MediaQuery.of(context).size.width * 0.4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        boardGame(1.9),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottomButtons(true),
            Column(
              children: [
                Text("Wins: $playerScore "),
                Text("Losses: $computerScore "),
                Text("Ties: $tiesScore "),
              ],
            ),
            if (_btnEnabled)
              Container(
                width: c_width,
                height: 80.0,
              ),
            if (!_btnEnabled) Container(width: c_width, child: winnerText()),
          ],
        ),
      ],
    );
  }

  Widget boardGame(double scaleContainer) {
    return Stack(children: <Widget>[
      Container(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/board.png',
          fit: BoxFit.scaleDown,
          scale: scaleContainer,
        ),
      ),
      Column(children: <Widget>[
        ..._Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
      ]),
    ]);
  }

  Widget winnerText() {
    final _estiloTexto = new TextStyle(fontSize: 32);
    return Text(winnerTextString,
        style: _estiloTexto, textAlign: TextAlign.center);
  }

  Widget _bottomButtons(bool isLandscape) {
    if (isLandscape) {
      return Column(children: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            setEmptyFields();
          },
          label: Text("New game"),
          icon: Icon(Icons.autorenew),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => showChangeDifficulty(),
          label: Text("Difficulty"),
          icon: const Icon(Icons.all_inclusive_outlined),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => exitGame(),
          label: Text("Quit"),
          icon: Icon(Icons.exit_to_app),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ]);
    } else {
      return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            onPressed: () {
              setEmptyFields();
            },
            label: Text("New game"),
            icon: Icon(Icons.autorenew),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            onPressed: () => showChangeDifficulty(),
            label: Text("Difficulty"),
            icon: const Icon(Icons.all_inclusive_outlined),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            onPressed: () => exitGame(),
            label: Text("Quit"),
            icon: Icon(Icons.exit_to_app),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ]);
    }
  }

  Widget gameButton(String labelText, Icon icon, int functionButton) {
    var action = null;
    if (functionButton == 1) {
      action = showChangeDifficulty();
    } else if (functionButton == 2) {
      action = exitGame();
    }
    return Expanded(
      flex: 1,
      child: ElevatedButton.icon(
        onPressed: () => action,
        label: Text(labelText),
        icon: icon,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget buildRow(int x) {
    final values = matrix[x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Widget buildField(int x, int y) {
    //AudioC
    String value = matrix[x][y];
    final color = getFieldColor(value);
    String value2 = "assets/images/empty.png";
    if (value == "X") {
      value2 = "assets/images/x.png";
    } else if (value == "O") {
      value2 = "assets/images/o.png";
    }

    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(size, size),
          primary: Colors.blue.withAlpha(0),
          elevation: 0,
          animationDuration: const Duration(hours: 0, minutes: 0, seconds: 0),
          shadowColor: Colors.blue.withAlpha(0),
          onPrimary: Colors.blue.withAlpha(0),
          onSurface: Colors.blue.withAlpha(0),
          splashFactory: NoSplash.splashFactory,
        ),
        //child: Text(value, style: const TextStyle(fontSize: 32, color: Colors.black)),
        child: Image.asset(value2, width: 150, height: 150),
        clipBehavior: Clip.none,
        onPressed: () {
          NoSplash.splashFactory;

          if (_btnEnabled) {
            _audioCache.play('draw.mp3');
            if (value == Player.openSpot &&
                (lastMove == Player.computerPlayer ||
                    lastMove == Player.openSpot)) {
              selectField(value, x, y);
            }
          }
        },
      ),
    );
  }

  void matrixChange(int matrixX) {
    if (matrixX == 0) {
      setMatrix0(matrix[0]);
    } else if (matrixX == 1) {
      setMatrix1(matrix[1]);
    } else if (matrixX == 2) {
      setMatrix2(matrix[2]);
    }
  }

  void selectField(String value, int x, int y) {
    const newValue = Player.humanPlayer;

    setState(() {
      setlastMove(newValue);
      lastMove = newValue;
      print("X:" + x.toString() + "Y: " + y.toString());
      matrix[x][y] = newValue;
      matrixChange(x);
    });

    if (isWinner(x, y, "X")) {
      setlastMove(Player.openSpot);
      lastMove = Player.openSpot;
      setBtnEnabled(false);
      _btnEnabled = false;
      setWinnerTextString("The winner is the Player");
      winnerTextString = "The winner is the Player";
      playerScore += 1;
      setPlayerScore(playerScore);
      return;
    } else if (isEnd()) {
      setlastMove(Player.openSpot);
      lastMove = Player.openSpot;
      setBtnEnabled(false);
      _btnEnabled = false;
      setWinnerTextString("It's a TIE");
      winnerTextString = "It's a TIE";
      tiesScore += 1;
      setTiesScore(tiesScore);
      return;
    }

    final temp = getComputerMove();

    x = temp.x;
    y = temp.y;

    if (isWinner(x, y, "O")) {
      setlastMove(Player.openSpot);
      lastMove = Player.openSpot;
      setBtnEnabled(false);
      _btnEnabled = false;
      setWinnerTextString("The winner is the Computer");
      winnerTextString = "The winner is the Computer";
      computerScore += 1;
      setComputerScore(computerScore);
    } else if (isEnd()) {
      setlastMove(Player.openSpot);
      lastMove = Player.openSpot;
      setBtnEnabled(false);
      _btnEnabled = false;
      setWinnerTextString("It's a TIE");
      winnerTextString = "It's a TIE";
      tiesScore += 1;
      setTiesScore(tiesScore);
    }
  }

  bool isEnd() => matrix
      .every((values) => values.every((value) => value != Player.openSpot));

  Coordinates getComputerMove() {
    const newValue = Player.computerPlayer;
    const n = countMatrix;

    if (mDifficultyLevel == difficultyLevel[0]) {
      dynamic xr;
      dynamic xy;
      var ranX = new Random();
      var ranY = new Random();
      xr = ranX.nextInt(3);
      xy = ranY.nextInt(3);

      while (matrix[xr][xy] != Player.openSpot) {
        xr = ranX.nextInt(3);
        xy = ranY.nextInt(3);
      }

      setState(() {
        setlastMove(newValue);
        lastMove = newValue;
        matrix[xr][xy] = newValue;
        matrixChange(xr);
      });
      return Coordinates(xr, xy);
    } else if (mDifficultyLevel == difficultyLevel[1]) {
      //Winning
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if ((matrix[i][j] == Player.openSpot) &&
              willWin(i, j, "O") &&
              lastMove == Player.humanPlayer) {
            setState(() {
              setlastMove(newValue);
              lastMove = newValue;
              matrix[i][j] = newValue;
              matrixChange(i);
            });
            return Coordinates(i, j);
          }
        }
      }

      //Random
      dynamic xr;
      dynamic xy;
      var ranX = new Random();
      var ranY = new Random();
      xr = ranX.nextInt(3);
      xy = ranY.nextInt(3);

      while (matrix[xr][xy] != Player.openSpot) {
        xr = ranX.nextInt(3);
        xy = ranY.nextInt(3);
      }

      setState(() {
        setlastMove(newValue);
        lastMove = newValue;
        matrix[xr][xy] = newValue;
        matrixChange(xr);
      });
      return Coordinates(xr, xy);
    } else {
      //Winning
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if ((matrix[i][j] == Player.openSpot) &&
              willWin(i, j, "O") &&
              lastMove == Player.humanPlayer) {
            setState(() {
              setlastMove(newValue);
              lastMove = newValue;
              matrix[i][j] = newValue;
              matrixChange(i);
            });
            return Coordinates(i, j);
          }
        }
      }
      //Blocking
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if ((matrix[i][j] == Player.openSpot) &&
              willWin(i, j, "X") &&
              lastMove == Player.humanPlayer) {
            setState(() {
              setlastMove(newValue);
              lastMove = newValue;
              matrix[i][j] = newValue;
              matrixChange(i);
            });
            return Coordinates(i, j);
          }
        }
      }

      //Random
      dynamic xr;
      dynamic xy;
      var ranX = new Random();
      var ranY = new Random();
      xr = ranX.nextInt(3);
      xy = ranY.nextInt(3);

      while (matrix[xr][xy] != Player.openSpot) {
        xr = ranX.nextInt(3);
        xy = ranY.nextInt(3);
      }

      setState(() {
        setlastMove(newValue);
        lastMove = newValue;
        matrix[xr][xy] = newValue;
        matrixChange(xr);
      });
      return Coordinates(xr, xy);
    }
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
    if (x == y) {
      if (x == 1) {
        rdiag++;
      }
      diag++;
    }
    if ((x == 0 && y == 2) || (x == 2 && y == 0)) {
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

  Future showChangeDifficulty() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.lightBlue,
          content: const Text('Reiniciar el juego'),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Radio(
                        value: difficultyLevel[0],
                        groupValue: mDifficultyLevel,
                        onChanged: (value) {
                          setEmptyFields();
                          setState(() {
                            mDifficultyLevel = difficultyLevel[0];
                          });
                          Navigator.of(context).pop();
                        }),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(difficultyLevel[0]),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: difficultyLevel[1],
                        groupValue: mDifficultyLevel,
                        onChanged: (value) {
                          setEmptyFields();
                          setState(() {
                            mDifficultyLevel = difficultyLevel[1];
                          });
                          Navigator.of(context).pop();
                        }),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(difficultyLevel[1]),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: difficultyLevel[2],
                        groupValue: mDifficultyLevel,
                        onChanged: (value) {
                          setEmptyFields();
                          setState(() {
                            mDifficultyLevel = difficultyLevel[2];
                          });
                          Navigator.of(context).pop();
                        }),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(difficultyLevel[2]),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    //setEmptyFields();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                )
              ],
            ),
          ],
        ),
      );

  Future exitGame() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.blue.withAlpha(150),
          content: const Text('¿Seguro desea cerrar el juego?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    SystemNavigator.pop();
                  },
                  child: const Text('Si'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                )
              ],
            ),
          ],
        ),
      );
}
