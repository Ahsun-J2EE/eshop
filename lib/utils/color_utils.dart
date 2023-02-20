import 'package:flutter/animation.dart';

import 'package:flutter/material.dart ';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toLowerCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
