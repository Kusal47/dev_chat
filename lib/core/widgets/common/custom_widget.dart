import 'package:flutter/material.dart';

Icon buildCustomIcon(
  IconData iconData, {
  Color? color,
  double? size,
}) {
  return Icon(
    iconData,
    color: color ?? Colors.white,
    size: size ?? 20,
  );
}

TextStyle customTextStyle({double? fontSize, Color? color, FontWeight? fontWeight, TextOverflow? overflow}) {
  return TextStyle(
      fontSize: fontSize ?? 14,
      color: color ?? Colors.white,
      fontWeight: fontWeight ?? FontWeight.normal,
      overflow:overflow?? TextOverflow.ellipsis
      );
}
