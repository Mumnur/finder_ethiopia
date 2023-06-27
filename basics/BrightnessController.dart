import 'package:flutter/material.dart';

class BrightnessController {
  bool isNightMode = false;

  Brightness get brightness => isNightMode ? Brightness.dark : Brightness.light;

  void toggleBrightness() {
    isNightMode = !isNightMode;
  }
}
