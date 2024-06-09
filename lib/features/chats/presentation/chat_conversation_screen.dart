import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/common/text_form_field.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:dev_chat/core/widgets/custom/chat_message_boxes.dart';
import 'package:dev_chat/features/chats/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../../core/api/firebase_request.dart';
import '../../../core/constants/encryption_services.dart';
import '../../../core/widgets/common/cached_network_image.dart';
import '../../../core/widgets/common/custom_widget.dart';
import '../../dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import '../model/message_model.dart';
import '../widgets/incoming_call_alert.dart';
import 'call_screen.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({
    super.key,
    required this.user,
  });

  final ChatUserResponseModel user;

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  @override
  void initState() {
    Get.put(ChatController());
    Get.find<ChatController>().generatetoken(AuthHelper().user!.uid);
    Get.find<ChatController>().generateCallId(widget.user.id.toString());
    Get.find<ChatController>().getChatUserBlockedList(widget.user.id.toString());

    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      final decryptedImage = widget.user.image != null && widget.user.image!.isNotEmpty
          ? EncryptionHelper().decryptData(widget.user.image.toString())
          : widget.user.image.toString();
      return BaseWidget(builder: (context, config, theme) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: StreamBuilder(
                  stream: FirebaseRequest().getUserInfo(widget.user),
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.only(
                        top: config.appVerticalPaddingMedium(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.offAllNamed(Routes.dashboard);
                                    },
                                    child: buildCustomIcon(Icons.arrow_back, size: 25),
                                  ),
                                ),
                                decryptedImage != null && decryptedImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: decryptedImage,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const CircleAvatar(
                                            radius: 22,
                                            child: Icon(Icons.person),
                                          ),
                                          errorWidget: (context, url, error) => const CircleAvatar(
                                            radius: 22,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          imageUrl: 'https://picsum.photos/200',
                                          placeholder: (context, url) => const CircleAvatar(
                                              radius: 50,
                                              backgroundColor: primaryColor,
                                              child: Icon(Icons.person)),
                                          errorWidget: (context, url, error) => const CircleAvatar(
                                              radius: 50,
                                              backgroundColor: primaryColor,
                                              child: Icon(Icons.person)),
                                        ),
                                      ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: config.appHorizontalPaddingMedium()),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.user.name.toString(),
                                            style: customTextStyle(fontSize: 16),
                                            softWrap: true,
                                            maxLines: 1,
                                          ),
                                        ),
                                        // Flexible(
                                        //   child: Text(
                                        //       softWrap: true,
                                        //       maxLines: 1,
                                        //       list.isNotEmpty
                                        //           ? list[0].isOnline == true
                                        //               ? 'Online'
                                        //               : DateFormatterUtils.getLastActiveTime(
                                        //                   context: context,
                                        //                   lastActive: list[0].lastActive.toString())
                                        //           : DateFormatterUtils.getLastActiveTime(
                                        //               context: context,
                                        //               lastActive:
                                        //                   widget.user.lastActive.toString()),
                                        //       style: customTextStyle(fontSize: 11)),
                                        // ),
                                        widget.user.isOnline == true &&
                                                controller.isBlockedUser == false
                                            ? Text("Active", style: customTextStyle(fontSize: 12))
                                            : Text("Offline", style: customTextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () async {
                                    if (controller.isBlockedUser == false) {
                                      log("Calling to ..." + widget.user.username.toString());

                                      try {
                                        var call = stream.StreamVideo.instance.makeCall(
                                          callType: stream.StreamCallType(),
                                          id: Get.find<ChatController>().callId,
                                        );
                                        controller.startACall(
                                            widget.user, Get.find<ChatController>().callId);
                                        await call.getOrCreate(
                                          ringing: true,
                                          notify: true,
                                          memberIds: [
                                            widget.user.name.toString(),
                                          ],
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CallScreen(call: call, user: widget.user),
                                          ),
                                        );
                                      } catch (e) {
                                        debugPrint('Error joining or creating call: $e');
                                        debugPrint(e.toString());
                                      }
                                    } else {
                                      showErrorToast("Call Disabled");
                                    }
                                  },
                                  child:
                                      buildCustomIcon(HeroIcons.phone, size: config.appHeight(3)),
                                )),
                                // Expanded(
                                //     child: GestureDetector(
                                //   onTap: () async {
                                //     // log("message");
                                //     // String callId =
                                //     //     await controller.getCallId(widget.user.id.toString());
                                //     // if (callId.isNotEmpty) {
                                //     //   var call = stream.StreamVideo.instance
                                //     //       .makeCall(callType: stream.StreamCallType(), id: callId);
                                //     //   Navigator.push(
                                //     //     context,
                                //     //     MaterialPageRoute(
                                //     //       builder: (context) => CallScreen(call: call),
                                //     //     ),
                                //     //   );
                                //     // } else {
                                //     //   showErrorToast("Call id not found");
                                //     // }
                                //   },
                                //   child: buildCustomIcon(HeroIcons.video_camera,
                                //       size: config.appHeight(2.5)),
                                // )),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.chatSettings, arguments: widget.user);
                                  },
                                  child: buildCustomIcon(Bootstrap.info_circle,
                                      size: config.appHeight(3)),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: controller.getMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          controller.messagesList =
                              data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

                          if (controller.messagesList.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: controller.messagesList.length,
                                itemBuilder: (context, index) {
                                  final message = controller.messagesList[index];

                                  return sentMessage(context, message, controller.isBlockedUser);
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: Column(
                                children: [
                                  decryptedImage != null && decryptedImage.isNotEmpty
                                      ? CustomCachedImage(
                                          imageUrl: decryptedImage,
                                          height: 100,
                                          width: 100,
                                        )
                                      : const CustomCachedImage(
                                          height: 100,
                                          width: 100,
                                          imageUrl: 'https://picsum.photos/200',
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.user.name.toString(),
                                      style: customTextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Say Hello',
                                          style: customTextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: '👋 ',
                                          style: customTextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                ],
                              ),
                            );
                          }
                      }
                    }),
                config.verticalSpaceCustom(0.15),
              ],
            ),
            floatingActionButton: controller.isBlockedUser == true
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("You can't send message"),
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomSheet: controller.isBlockedUser == true
                ? null
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Form(
                      key: formKey,
                      child: Container(
                        color: backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: dividerColor,
                                      )),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: PrimaryFormField(
                                          readOnly: controller.isBlockedUser == true ? true : false,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          contentPadding: const EdgeInsets.all(8),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.transparent,
                                          )),
                                          enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.transparent,
                                          )),
                                          controller: controller.messageController,
                                          hintTxt: controller.isBlockedUser == true
                                              ? "You can't send messages."
                                              : 'Type a message...',
                                          onSaved: (value) {
                                            controller.messageController.text = value;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  if (controller.isBlockedUser == false) {
                                                    await controller.clickImage(
                                                        context, widget.user);
                                                  }
                                                },
                                                child: buildCustomIcon(Bootstrap.camera,
                                                    size: 25, color: primaryColor),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                  onTap: () async {
                                                    if (controller.isBlockedUser == false) {
                                                      await controller.pickGallaryImage(
                                                          context, widget.user);
                                                    }
                                                  },
                                                  child: buildCustomIcon(Bootstrap.image,
                                                      size: 25, color: primaryColor)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (controller.isBlockedUser == false) {
                                      if (formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        if (controller.messageController.text.isNotEmpty) {
                                          controller.sendMessage(widget.user,
                                              controller.messageController.text, Type.text);
                                        }
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildCustomIcon(Bootstrap.send,
                                        size: 25, color: primaryColor),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        );
      });
    });
  }
}
