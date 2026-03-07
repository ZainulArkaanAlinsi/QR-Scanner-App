import 'package:flutter/material.dart';

class Helper {
  /// Unfocuses the primary focus when tapping outside.
  static void onTapOutside(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
