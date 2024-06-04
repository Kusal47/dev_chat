import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/constants/date_formatter.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/common/text_form_field.dart';
import 'package:dev_chat/core/widgets/custom/chat_message_boxes.dart';
import 'package:dev_chat/features/chats/controller/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import '../../../core/api/firebase_request.dart';
import '../../../core/constants/encryption_services.dart';
import '../../../core/widgets/common/custom_widget.dart';
import '../../dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import '../model/message_model.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({super.key, required this.user});

  final ChatUserResponseModel user;

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  @override
  void initState() {
    Get.put(ChatController());

    super.initState();
  }

  // void scrollToEnd() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController.hasClients) {
  //       scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //     }
  //   });
  // }

  final formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

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
                    // final data = snapshot.data?.docs;
                    // final list =
                    //     data?.map((e) => ChatUserResponseModel.fromJson(e.data())).toList() ?? [];

                    return Container(
                      padding: EdgeInsets.only(
                        top: config.appVerticalPaddingMedium(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
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
                                    : const CircleAvatar(
                                        radius: 21,
                                        child: Icon(
                                          CupertinoIcons.person,
                                          size: 22,
                                        )),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: config.appHorizontalPaddingMedium()),
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width * 0.4,
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
                                        widget.user.isOnline == true
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
                                    child: buildCustomIcon(HeroIcons.phone,
                                        size: config.appHeight(2.5))),
                                Expanded(
                                    child: buildCustomIcon(HeroIcons.video_camera,
                                        size: config.appHeight(2.5))),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.chatSettings, arguments: widget.user);
                                  },
                                  child: buildCustomIcon(Bootstrap.info_circle,
                                      size: config.appHeight(2.5)),
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
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            //   scrollController.animateTo(
                            //       curve: Curves.easeIn,
                            //       duration: Duration(milliseconds: 300),
                            //       scrollController.position.maxScrollExtent);
                            // });
                            return Expanded(
                              child: ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                // controller: scrollController,

                                // physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.messagesList.length,
                                itemBuilder: (context, index) {
                                  final message = controller.messagesList[index];
                                  // final isUserMessage = message.sender == AuthHelper().user.uid;
                                  // return isUserMessage
                                  //     ? sentMessage(message)
                                  //     : receivedMessage(message);

                                  return sentMessage(context, message);
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: Column(
                                children: [
                                  decryptedImage != null && decryptedImage.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: decryptedImage,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const CircleAvatar(
                                              radius: 50,
                                              child: Icon(Icons.person),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                const CircleAvatar(
                                              radius: 50,
                                              child: Icon(Icons.person),
                                            ),
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 50,
                                          child: Icon(
                                            CupertinoIcons.person,
                                            size: 70,
                                          )),
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
            bottomSheet: Padding(
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
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    contentPadding: EdgeInsets.all(8),
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
                                    hintTxt: 'Type a message...',
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
                                            await controller.clickImage(context, widget.user);
                                          },
                                          child: buildCustomIcon(Bootstrap.camera,
                                              size: 25, color: primaryColor),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              await controller.pickGallaryImage(
                                                  context, widget.user);
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
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                if (controller.messageController.text.isNotEmpty) {
                                  controller.sendMessage(
                                      widget.user, controller.messageController.text, Type.text);
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: buildCustomIcon(Bootstrap.send, size: 25, color: primaryColor),
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
