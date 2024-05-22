import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../resources/colors.dart';

void showSuccessToast(String message, {Color? color}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color ?? Colors.green,
      textColor: backgroundColor,
      fontSize: 16.0);
}

void showErrorToast(String message, {Color? color}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color ?? Colors.red,
      textColor: backgroundColor,
      fontSize: 16.0);
}
