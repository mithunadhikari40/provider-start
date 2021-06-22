import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool val) {
    _busy = val;
    notifyListeners();
  }
}
