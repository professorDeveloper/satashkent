import 'package:flutter/material.dart';

import '../storage/hive_service.dart';

class ThemeController extends ChangeNotifier {
  final HiveService _hive;
  ThemeMode _mode;

  ThemeController(this._hive) : _mode = _decode(_hive.getThemeMode());

  ThemeMode get mode => _mode;
  bool get isDark =>
      _mode == ThemeMode.dark ||
      (_mode == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark);

  Future<void> toggle() async {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    await _hive.saveThemeMode(_mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  static ThemeMode _decode(String s) => switch (s) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
