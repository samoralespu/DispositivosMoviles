import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get lastMove {
    return _prefs.getString('lastMove') ?? '';
  }

  set lastMove(String value) {
    _prefs.setString('lastMove', value);
  }

  /*String lastMove;
  String winnerTextString;
  bool _btnEnabled;
  String mDifficultyLevel;*/
}
