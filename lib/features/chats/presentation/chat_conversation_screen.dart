import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/common/text_form_field.dart';
import 'package:dev_chat/core/widgets/custom/chat_message_boxes.dart';
import 'package:dev_chat/features/chats/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
// import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../../core/api/firebase_request.dart';
import '../../../core/constants/encryption_services.dart';
import '../../../core/widgets/common/cached_network_image.dart';
import '../../../core/widgets/common/custom_widget.dart';
import '../../dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import '../model/message_model.dart';

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
    Get.put(ChatController()).generatetoken(AuthHelper().user!.uid);
    Get.put(ChatController()).generateCallId(widget.user.id.toString());

    super.initState();
    // stream.StreamVideo.reset();
    // final client = stream.StreamVideo(
    //   '73u4jjq2tunh', //getStream api key
    //   user: stream.User.regular(
    //       userId: AuthHelper().user!.uid, //current user id

    //       role: 'user',
    //       name: widget.user.name),
    //   userToken: Get.find<ChatController>().token, // token of current user logged in
    //   // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiWmFtX1dlc2VsbCIsImlzcyI6Imh0dHBzOi8vcHJvbnRvLmdldHN0cmVhbS5pbyIsInN1YiI6InVzZXIvWmFtX1dlc2VsbCIsImlhdCI6MTcxNzU2NTIzMywiZXhwIjoxNzE4MTcwMDM4fQ.WTyCEra6haM66h7aqUeK84lObnNLNxilxrkn7cqZB-0',
    // );
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
                                    child: GestureDetector(
                                  onTap: () async {
                                    log(AuthHelper().user!.uid);
                                    log(widget.user.id.toString());
                                    // ZegoSendCallInvitationButton(invitees: [
                                    //   ZegoUIKitUser(
                                    //       id: widget.user.id.toString(),
                                    //       name: widget.user.name.toString()),
                                    // ], isVideoCall: true);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) {
                                    //     return CallPage(callID: Get.find<ChatController>().callId);
                                    //   }),
                                    // );
                                    // try {
                                    //     var call = stream.StreamVideo.instance.makeCall(
                                    //       callType: stream.StreamCallType(),
                                    //       id: Get.find<ChatController>().callId,
                                    //     );

                                    //     await call.getOrCreate(ringing: true, notify: true);

                                    //     FirebaseFirestore.instance
                                    //         .collection('calls')
                                    //         .doc(Get.find<ChatController>().callId)
                                    //         .set({
                                    //           'callerId': AuthHelper().user!.uid,
                                    //           'receiverId': widget.user.id,
                                    //           'status': 'ringing',
                                    //         })
                                    //         .then((value) => log('Call started'))
                                    //         .catchError(
                                    //             (error) => log('Failed to start call: $error'));

                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => CallScreen(call: call),
                                    //       ),
                                    //     );
                                    // } catch (e) {
                                    //   debugPrint('Error joining or creating call: $e');
                                    //   debugPrint(e.toString());
                                    // }
                                  },
                                  child:
                                      buildCustomIcon(HeroIcons.phone, size: config.appHeight(2.5)),
                                )),
                                // Expanded(
                                //     child: buildCustomIcon(HeroIcons.video_camera,
                                //         size: config.appHeight(2.5))),
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
                            return Expanded(
                              child: ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: controller.messagesList.length,
                                itemBuilder: (context, index) {
                                  final message = controller.messagesList[index];

                                  return sentMessage(context, message);
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
                              padding: const EdgeInsets.all(8.0),
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

// class CallPage extends StatelessWidget {
//   const CallPage({Key? key, required this.callID}) : super(key: key);
//   final String callID;

//   @override
//   Widget build(BuildContext context) {
//     User user = FirebaseAuth.instance.currentUser!;
//     return ZegoUIKitPrebuiltCall(
//         appID: 1991925933, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign:
//             "c16e9be110bb522d16f99a0b7d773180f86e58ceecbf66dd8de06513542f76bd", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: user.uid,
//         userName: user.displayName.toString(),
//         callID: callID,
//         // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//         config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//         // ..onOnlySelfInRoom = () => Navigator.of(context).pop(),
//         );
//   }
// }
// class CallScreen extends StatefulWidget {
//   final stream.Call call;

//   const CallScreen({
//     Key? key,
//     required this.call,
//   }) : super(key: key);

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: stream.StreamCallContainer(
//         call: widget.call,
//         onLeaveCallTap: () async {
//           await widget.call.leave();
//           Navigator.pop(context);
//         },
//         callContentBuilder: (
//           BuildContext context,
//           stream.Call call,
//           stream.CallState callState,
//         ) {
//           return stream.StreamCallContent(
//             call: call,
//             callState: callState,
//             callControlsBuilder: (
//               BuildContext context,
//               stream.Call call,
//               stream.CallState callState,
//             ) {
//               final localParticipant = callState.localParticipant!;
//               return stream.StreamCallControls(
//                 options: [
//                   stream.FlipCameraOption(
//                     call: call,
//                     localParticipant: localParticipant,
//                   ),
//                   stream.ToggleMicrophoneOption(
//                     call: call,
//                     localParticipant: localParticipant,
//                   ),
//                   stream.ToggleCameraOption(
//                     call: call,
//                     localParticipant: localParticipant,
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
