import 'dart:developer';

import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/custom/chat_tiles.dart';
import 'package:dev_chat/core/widgets/custom/search_bar.dart';
import 'package:dev_chat/features/auth/controller/auth_controller.dart';
import 'package:dev_chat/features/chats/model/message_model.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/api/notification._api.dart';
import '../../../../search/presentation/search_screen.dart';
import 'test_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
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
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                      Get.toNamed(Routes.searchScreen,arguments: controller.userList);
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
                                  return CustomChatTiles(
                                    user: user,
                                  );
                                },
                              );
                            } else {
                              return const Center(child: Text('No User Found'));
                            }
                          default:
                            return const Center(child: Text('Something went wrong'));
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
