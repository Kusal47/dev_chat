import 'package:flutter/material.dart';
import '../../core/resources/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    required this.appTitle,
    this.onTap,
    super.key,
  });

  final String appTitle;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(
        size: 18, //change size on your need
        color: Colors.black, //change color on your need
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 100,
      leading: InkWell(
        onTap: onTap ??
            () {
              Navigator.pop(context);
            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text(
              appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14,
                    color: blackColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
