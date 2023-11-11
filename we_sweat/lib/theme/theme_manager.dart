import 'package:flutter/material.dart';
import 'package:we_sweat/theme/colors.dart';
import 'theme.dart';

class ThemeManager extends ChangeNotifier {
  ThemeManager();

  // The ThemeData object which the app uses
  ThemeData? _themeData;
  ThemeData get themeData {
    _themeData ??= appThemeData[AppTheme.LIGHT];
    return _themeData!;
  }

  switchTheme() async {
    if (_themeData == appThemeData[AppTheme.LIGHT]) {
      _themeData = appThemeData[AppTheme.DARK];
    } else {
      _themeData = appThemeData[AppTheme.LIGHT];
    }

    notifyListeners();
  }

  AppColors get colors {
    return AppColors(
      backgroundColor: const Color(0xff040303),
      light: const Color(0xffFFF1D5),
      highlight: const Color(0xff78CCCB),
      dark: const Color(0xff232331),
      mid: const Color(0xff247BA0),
    );
  }
}
