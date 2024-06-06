import 'dart:developer';

import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/resources/ui_assets.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/widgets/custom/chat_tiles.dart';
import '../../chats/model/message_model.dart';
import '../../dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import '../../search/presentation/search_screen.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
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
              onPressed: () {
                Get.toNamed(Routes.searchScreen, arguments: controller.suggestedUser);
                // Get.to(() => SearchScreen(userLists: controller.suggestedUser));
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: StreamBuilder(
            stream: controller.getUserDatafromfirebase(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  controller.suggestedUser =
                      data?.map((e) => ChatUserResponseModel.fromJson(e.data())).toList() ?? [];

                  if (controller.suggestedUser.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.suggestedUser.length,
                        itemBuilder: (context, index) {
                          final user = controller.suggestedUser[index];
                          return CustomChatTiles(
                            isSuggestion: true,
                            user: user,
                            onAddUser: () => controller.addUser(user.id.toString()),
                          );
                        });
                  } else {
                    return const Center(child: Text('No User Found'));
                  }
              }
            }),
    
      );
    });
  }
}

// class PeopleScreen extends StatelessWidget {
//   const PeopleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     MessageModel? messageModel;
//     return GetBuilder<HomeController>(builder: (controller) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//               onTap: () {
//               },
//               child: SvgPicture.asset(
//                 UIAssets.appLogo,
//                 colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
//               )),
//           title: const Text('devChat'),
//           centerTitle: true,
//           // actions: [
//           //   IconButton(
//           //     onPressed: () {},
//           //     icon: Icon(Icons.edit_square),
//           //   )
//           // ],
//         ),
//         body: StreamBuilder(
//             stream: controller.getUserDatafromfirebase(),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                 case ConnectionState.none:
//                 case ConnectionState.active:
//                 case ConnectionState.done:
//                   final data = snapshot.data?.docs;

//                   controller.userList =
//                       data?.map((e) => ChatUserResponseModel.fromJson(e.data())).toList() ?? [];

//                   DateTime now = DateTime.now();
//                   String formattedDateTime = DateFormat(' hh:mm a').format(now);

//                   if (controller.userList.isNotEmpty) {
//                     return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: controller.userList.length,
//                         itemBuilder: (context, index) {
//                           final user = controller.userList[index];
//                           return CustomChatTiles(
//                                   isSuggestion: true,
//                                   user: user,
//                                 );
//                         });
//                   } else {
//                     return const Center(child: Text('No User Found'));
//                   }
//               }
//             }),
//       );
//     });
//   }
// }
