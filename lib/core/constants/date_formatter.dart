import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatterUtils {
  static String formatDateFromString(String? stringDate) {
    if (stringDate != null) {
      final date = DateTime.tryParse(stringDate) ?? DateTime.now();

      final formatter = DateFormat('MMM, d, y');

      return formatter.format(date);
    }

    return "null";
  }
static String formatTime(Timestamp? stringDate) {
  if (stringDate != null) {
    final timestamp = int.tryParse(stringDate.millisecondsSinceEpoch.toString());
    if (timestamp != null) {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formatter = DateFormat('hh:mm a');
      return formatter.format(date);
    }
  }
  return "null";
}

  // static String formatTime(String? stringDate) {
  //   if (stringDate != null) {
  //     final date = DateTime.tryParse(stringDate) ?? DateTime.now();

  //     final formatter = DateFormat('hh:mm a');

  //     return formatter.format(date);
  //   }

  //   return "null";
  // }
    static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
