import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class NotificationWidget extends StatelessWidget {
  final String? date;
  final String? message;
  const NotificationWidget({
    super.key,
    this.date,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: dimGreyColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message ?? "",
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
