import 'dart:developer';

import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/custom/chat_tiles.dart';
import 'package:dev_chat/core/widgets/custom/search_bar.dart';
import 'package:dev_chat/features/auth/controller/auth_controller.dart';
import 'package:dev_chat/features/chats/controller/chat_controller.dart';
import 'package:dev_chat/features/chats/model/message_model.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/api/notification._api.dart';
import '../../../../../core/widgets/custom/list_tiles.dart';
import '../../../../search/presentation/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    NotificationClass().getFirebaseMessagingToken();
    Get.put(AuthController());
    // SystemChannels.lifecycle.setMessageHandler((message) {
    //   if (FirebaseRequest().authHelper.user != null) {
    //     if (message.toString().contains('resume')) {
    //       FirebaseRequest().updateActiveStatus(true);
    //     }
    //     if (message.toString().contains('pause')) {
    //       FirebaseRequest().updateActiveStatus(false);
    //     }
    //   }

    //   return Future.value(message);
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return BaseWidget(builder: (context, config, theme) {
      return GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      // Get.to(() => TestClass());
                    },
                    child: SvgPicture.asset(
                      UIAssets.appLogo,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    )),
                title: const Text('devChat'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  SearchBarWidget(
                    readOnly: true,
                    title: 'Search Friends',
                    onTap: () {
                      Get.toNamed(Routes.searchScreen, arguments: controller.userList);
                      // Get.to(() => SearchScreen(userLists: controller.userList));
                    },
                    onSaved: (e) {},
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: controller.getFollowedUserData(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            controller.userList = data
                                    ?.map((e) => ChatUserResponseModel.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (controller.userList.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.userList.length,
                                itemBuilder: (context, index) {
                                  final user = controller.userList[index];
                                  return InkWell(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              titlePadding: EdgeInsets.zero,
                                              actionsPadding: EdgeInsets.zero,
                                              contentPadding: EdgeInsets.zero,
                                              content: Container(
                                                color: backgroundColor,
                                                height: Get.height * 0.3,
                                                width: Get.width * 0.3,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ListTilesCustom(
                                                      leadingWidget: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      onTap: () {
                                                        controller.removeUser(
                                                            context, user.id.toString());
                                                      },
                                                      text: 'Unfollow',
                                                    ),
                                                    ListTilesCustom(
                                                      leadingWidget: const Icon(
                                                        Icons.block,
                                                        color: Colors.red,
                                                      ),
                                                      onTap: () {
                                                        Get.put(ChatController()).blockedUser(
                                                            context, user.id.toString(), false);
                                                      },
                                                      text: 'Block',
                                                    ),
                                                    ListTilesCustom(
                                                      leadingWidget: const Icon(
                                                        Icons.report,
                                                        color: Colors.red,
                                                      ),
                                                      onTap: () {
                                                        // controller
                                                        //     .followUser(user);
                                                        // Get.back();
                                                      },
                                                      text: 'Report',
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: CustomChatTiles(
                                      user: user,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(child: Text('No User Found'));
                            }
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     NotificationClass().getFirebaseMessagingToken();
//     Get.put(AuthController());
//     SystemChannels.lifecycle.setMessageHandler((message) {
//       if (FirebaseRequest().authHelper.user != null) {
//         if (message.toString().contains('resume')) {
//           FirebaseRequest().updateActiveStatus(true);
//         }
//         if (message.toString().contains('pause')) {
//           FirebaseRequest().updateActiveStatus(false);
//         }
//       }

//       return Future.value(message);
//     });

//     super.initState();
//   }

//   MessageModel? messageModel;
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>();
//     return BaseWidget(builder: (context, config, theme) {
//       return GetBuilder<HomeController>(
//           init: HomeController(),
//           builder: (controller) {
//             return Scaffold(
//               appBar: AppBar(
//                 leading: GestureDetector(
//                     onTap: () {
//                       // Get.to(() => TestClass());
//                     },
//                     child: SvgPicture.asset(
//                       UIAssets.appLogo,
//                       colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
//                     )),
//                 title: const Text('devChat'),
//                 centerTitle: true,
//               ),
//               body: Column(
//                 children: [
//                   SearchBarWidget(
//                     readOnly: true,
//                     title: 'Search Friends',
//                     onTap: () {
//                       Get.to(() => SearchScreen(
//                             userLists: controller.userList,
//                           ));
//                     },
//                     onSaved: (e) {},
//                   ),
//                   Expanded(
//                     child: StreamBuilder(
//                         stream: controller.getUserDatafromfirebase(),
//                         builder: (context, snapshot) {
//                           switch (snapshot.connectionState) {
//                             case ConnectionState.waiting:
//                             case ConnectionState.none:
//                             // return const Center(
//                             //   child: CircularProgressIndicator(),
//                             // );
//                             case ConnectionState.active:
//                             case ConnectionState.done:
//                               final data = snapshot.data?.docs;

//                               controller.userList = data
//                                       ?.map((e) => ChatUserResponseModel.fromJson(e.data()))
//                                       .toList() ??
//                                   [];

//                               DateTime now = DateTime.now();
//                               String formattedDateTime = DateFormat(' hh:mm a').format(now);

//                               if (controller.userList.isNotEmpty) {
//                                 return ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: controller.userList.length,
//                                     itemBuilder: (context, index) {
//                                       final user = controller.userList[index];
//                                       return  CustomChatTiles(
//                                               user: user,
//                                             );
//                                     });
//                               } else {
//                                 return const Center(child: Text('No User Found'));
//                               }
//                           }
//                         }),
//                   ),
//                 ],
//               ),
//             );
//           });
//     });
//   }
// }
