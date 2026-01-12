import 'package:flutter/material.dart';

class TextScale {
  static double scale(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    // Tablet or landscape → lock scale
    if (shortestSide >= 600) {
      return 1.0;
    }

    // Phone → allow scaling
    return MediaQuery.of(context).textScaleFactor;
  }
}
