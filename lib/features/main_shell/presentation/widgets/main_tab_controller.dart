import 'package:flutter/foundation.dart';

class MainTabController extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void goto(int next) {
    if (next == _index) return;
    _index = next;
    notifyListeners();
  }

  void reset() {
    _index = 0;
  }
}
