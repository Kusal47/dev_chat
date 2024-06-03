import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../core/resources/ui_assets.dart';
import '../../../core/widgets/custom/chat_tiles.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              // authController.logout(context);
            },
            child: SvgPicture.asset(
              UIAssets.appLogo,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )),
        title: const Text('devChat'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_square),
          )
        ],
      ),
      // body: ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: 20,
      //     itemBuilder: (_, context) {
      //       return CustomChatTiles(isSuggestion: true);
      //     }),
    );
  }
}
