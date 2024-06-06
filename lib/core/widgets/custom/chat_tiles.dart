import 'dart:developer';

import 'package:dev_chat/core/constants/encryption_services.dart';
import 'package:dev_chat/core/widgets/custom/list_tiles.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../features/chats/model/message_model.dart';
import '../../../features/dashboard/presentation/home_screen/controller/home_controller.dart';
import '../../constants/date_formatter.dart';
import '../../routes/app_pages.dart';

class CustomChatTiles extends StatelessWidget {
  final ChatUserResponseModel user;

  const CustomChatTiles(
      {super.key, this.isSuggestion = false, this.onTap, this.onAddUser, required this.user});
  final bool isSuggestion;
  final Function()? onTap;
  final Function()? onAddUser;

  @override
  Widget build(BuildContext context) {
    MessageModel? messageModel;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(40.0),
            color: Colors.grey[50],
            // border: Border.all(
            //   color: Colors.grey,
            //   width: 1.0,
            // )
          ),
          child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return StreamBuilder(
                    stream: controller.getLastMessage(user),
                    builder: (context, snapshot) {
                      final messageData = snapshot.data?.docs;

                      final lastMessageList =
                          messageData?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
                      if (lastMessageList.isNotEmpty) {
                        messageModel = lastMessageList[0];
                      }

                      final decryptedImage = user.image != null && user.image!.isNotEmpty
                          ? EncryptionHelper().decryptData(user.image.toString())
                          : user.image;

                      return ListTilesWidget(
                          image: decryptedImage,
                          onTap:isSuggestion ? null : onTap ??
                              () {
                                Get.toNamed(Routes.chat, arguments: user);
                              },
                          radius: 30,
                          icon: Bootstrap.person,
                          title: user.name ?? '',
                          subtitle: messageModel != null
                              ? messageModel!.type == Type.image
                                  ? 'Sent Image'
                                  : EncryptionHelper()
                                      .decryptData(messageModel?.msg.toString() ?? '')
                              : user.about.toString(),
                          dateTime: messageModel?.sentTime != null
                              ? DateFormatterUtils.formatTime(messageModel?.sentTime)
                              : '',
                          trailIcon: isSuggestion ? Bootstrap.person_add : null,
                          onAddUser: onAddUser,
                          );
                    });
              })),
    );
  }
}
