import 'package:dev_chat/core/resources/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom/list_tiles.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const DrawerHeader(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: UserAccountsDrawerHeader(
              accountName: Text(
                "Kushal Aryal",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text("kusalaryal@gmail.com"),
              currentAccountPictureSize: Size.square(50),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'K',
                  style: TextStyle(fontSize: 30.0, color: Colors.blue),
                ),
              ),
            ),
          ),
          ListTilesCustom(
            leadingWidget: const Icon(Icons.person),
            text: ' My Profile ',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTilesCustom(
            leadingWidget: const Icon(Icons.person),
            text: ' Edit Profile ',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTilesCustom(leadingWidget: const Icon(Icons.logout), text: 'LogOut', onTap: onTap),
        ],
      ),
    );
  }
}
