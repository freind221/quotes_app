import 'package:flutter/cupertino.dart';

import 'package:quota_app/controller/db_handler.dart';
import 'package:quota_app/models/search_model.dart';
import 'package:quota_app/utilis/constant.dart';

class AppProvider with ChangeNotifier {
  DBhelper dbHelper = DBhelper();

  TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  String someValue = '';

  updateSomeValue(String newValue, bool val) {
    someValue = newValue;
    _check = val;
    notifyListeners();
  }

  String _text = '';
  bool _check = false;
  bool _authorCheck = false;
  int _limit = 10;
  setText(String rol, bool val) {
    _text = rol;
    _authorCheck = val;
    notifyListeners();
  }

  setCheck(bool rol) {
    _check = rol;
    notifyListeners();
  }

  increment() {
    if (_limit < 100) {
      _limit++;
    }
    notifyListeners();
  }

  decrement() {
    if (_limit > 1) {
      _limit--;
    }

    notifyListeners();
  }

  String get text => _text;
  bool get check => _check;
  bool get authorCheck => _authorCheck;
  int get limit => _limit;

  late Future<List<Searches>> _quotes;
  Future<List<Searches>> get quotes => _quotes;

  Future<List<Searches>> getData() async {
    _quotes = dbHelper.getNotes();
    noteslist = dbHelper.getNotes();
    notifyListeners();
    return _quotes;
  }

  setList(Future<List<Searches>> quotes) {
    _quotes = quotes;
    notifyListeners();
  }
}
