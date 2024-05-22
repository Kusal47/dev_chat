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
        size: 25, //change size on your need
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.arrow_back_ios,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
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
