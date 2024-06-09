import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/common/show_dialog_box.dart';
import 'package:dev_chat/core/widgets/custom/chat_tiles.dart';
import 'package:dev_chat/features/chats/controller/chat_controller.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BlockedUserListScreen extends StatefulWidget {
  const BlockedUserListScreen({super.key});

  @override
  State<BlockedUserListScreen> createState() => _BlockedUserListScreenState();
}

class _BlockedUserListScreenState extends State<BlockedUserListScreen> {
  @override
  void initState() {
    Get.put(ChatController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return BaseWidget(builder: (context, config, theme) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Get.offAllNamed(Routes.dashboard);
                  Get.put(HomeController()).changeIndex(2);
                },
                child: Icon(Icons.arrow_back)),
            automaticallyImplyLeading: false,
            title: const Text('Blocked Users'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // SearchBarWidget(
              //   readOnly: true,
              //   title: 'Search Friends',
              //   onTap: () {
              //     Get.toNamed(Routes.searchScreen, arguments: controller.blockedList);
              //     // Get.to(() => SearchScreen(blockedLists: controller.blockedList));
              //   },
              //   onSaved: (e) {},
              // ),
              Expanded(
                child: StreamBuilder(
                  stream: controller.getBlockedUser(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        controller.blockedList =
                            data?.map((e) => ChatUserResponseModel.fromJson(e.data())).toList() ??
                                [];

                        if (controller.blockedList.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.blockedList.length,
                            itemBuilder: (context, index) {
                              final user = controller.blockedList[index];
                              return CustomChatTiles(
                                blockedUser: true,
                                user: user,
                                unBlockedUser: () {
                                  showDialogBox(
                                    context,
                                    () {
                                      controller.blockedUser(context, user.id.toString(), true);
                                    },
                                    description: "Are you sure you want to unblock this user?",
                                  );
                                },
                                iconColor: Colors.red,
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('No Blocked User Found'));
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
