import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/widgets/common/custom_widget.dart';
import 'package:dev_chat/core/widgets/common/text_form_field.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:dev_chat/features/chats/controller/chat_controller.dart';
import 'package:dev_chat/features/chats/model/message_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../api/firebase_request.dart';
import '../../constants/date_formatter.dart';
import '../../constants/encryption_services.dart';
import '../common/cached_network_image.dart';
import 'custom_options_widget.dart';

Widget receivedMessage(MessageModel message) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          DateFormatterUtils.formatTime(message.sentTime),
          style: customTextStyle(fontSize: 12, color: dividerColor),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: SizedBox(
              width: Get.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5, color: dividerColor)),
                    child: message.type == Type.text
                        ? Text(
                            message.msg.toString(),
                            style: customTextStyle(fontSize: 14, color: Colors.white),
                          )
                        : CustomCachedImage(
                            imageUrl: message.msg.toString(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget sentMessage(BuildContext context, MessageModel message, bool isBlockedUser) {
  // if (message.sender != AuthHelper().user!.uid) {
  //   if (message.read != null && message.read!.isEmpty) {
  //     FirebaseRequest().updateMessageReadStatus(message);
  //   }
  // }

  final decryptMessage = EncryptionHelper().decryptData(message.msg.toString());

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          DateFormatterUtils.formatTime(message.sentTime),
          style: customTextStyle(fontSize: 12, color: dividerColor),
        ),
      ),
      Row(
        mainAxisAlignment: message.sender == AuthHelper().user!.uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: SizedBox(
              width: Get.width * 0.8,
              child: Align(
                alignment: message.sender == AuthHelper().user!.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () => displayBottomSheet(context, message),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: message.sender == AuthHelper().user!.uid
                              ? Colors.lightBlueAccent
                              : Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5, color: dividerColor),
                        ),
                        child: message.type == Type.text
                            ? Text(
                                decryptMessage,
                                style: customTextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    overflow: TextOverflow.visible),
                              )
                            : CustomCachedImage(
                                imageUrl: decryptMessage.toString(),
                              ),
                      ),
                    ),
                    // Visibility(
                    //   visible: message.sender == AuthHelper().user!.uid &&
                    //       message.read?.isNotEmpty == true,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 5),
                    //     child: buildCustomIcon(Icons.done_all_sharp, size: 20, color: Colors.green),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

void displayBottomSheet(BuildContext context, MessageModel message) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0))),
      builder: (_) {
        return GetBuilder<ChatController>(
            init: Get.find<ChatController>(),
            builder: (controller) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),

                  message.type == Type.text
                      ? CustomOptions(
                          icon: const Icon(Icons.copy_all_rounded, color: Colors.blue, size: 26),
                          name: 'Copy Text',
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                    text: EncryptionHelper().decryptData(message.msg.toString())))
                                .then((value) {
                              showSuccessToast('Copied Successfully!');
                              Get.back();
                            });
                          })
                      : CustomOptions(
                          icon: const Icon(Icons.download_rounded, color: Colors.blue, size: 26),
                          name: 'Save Image',
                          onTap: () async {
                            try {
                              final imageUrldecrypt =
                                  EncryptionHelper().decryptData(message.msg.toString());
                              log('Image Url: $imageUrldecrypt');

                              // Download the image using Dio
                              final response = await Dio().get(
                                imageUrldecrypt,
                                options: Options(responseType: ResponseType.bytes),
                              );

                              if (response.statusCode == 200) {
                                final Uint8List imageData = Uint8List.fromList(response.data);

                                // Save the image
                                final result = await ImageGallerySaver.saveImage(
                                  imageData,
                                  name: 'devChatImage',
                                  quality: 100,
                                );

                                if (result['isSuccess']) {
                                  showSuccessToast('Image Successfully Saved!');
                                } else {
                                  log('ErrorWhileSavingImg: ${result['errorMessage']}');
                                }
                                Get.back();
                              } else {
                                log('ErrorWhileDownloadingImg: ${response.statusCode}');
                                Get.back();
                              }
                            } catch (e) {
                              log('ErrorWhileSavingImg: $e');
                              Get.back();
                            }
                          },
                        ),

                  const Divider(
                    color: Colors.black54,
                    endIndent: 10,
                    indent: 10,
                  ),

                  //edit option
                  if (message.sender == AuthHelper().user!.uid && message.type == Type.text)
                    CustomOptions(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                        name: 'Edit Message',
                        onTap: () {
                          Get.back();

                          editDialogBox(context, message);
                        }),

                  if (message.sender == AuthHelper().user!.uid)
                    CustomOptions(
                        icon: const Icon(Icons.delete_forever, color: Colors.red, size: 26),
                        name: 'Delete Message',
                        onTap: () async {
                          await controller.deleteMessage(context, message);
                          Get.back();
                        }),
                ],
              );
            });
      });
}

editDialogBox(BuildContext context, MessageModel message) {
  String updatedMsg = EncryptionHelper().decryptData(message.msg.toString());

  showDialog(
      context: context,
      builder: (_) => GetBuilder<ChatController>(
          init: Get.find<ChatController>(),
          builder: (controller) {
            return AlertDialog(
              contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Bootstrap.chat,
                      color: blackColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    'Update Message',
                    style: customTextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700, color: blackColor),
                  )
                ],
              ),
              content: Form(
                child: PrimaryFormField(
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) => updatedMsg = value,
                  initialValue: updatedMsg,
                  maxLines: null,
                  onChanged: (value) => updatedMsg = value,
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () async {
                      await controller.editMessage(context, message, updatedMsg);
                      Get.back();
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            );
          }));
}
