import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/widgets/common/custom_widget.dart';
import 'package:dev_chat/features/chats/model/message_model.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../api/firebase_request.dart';
import '../../constants/date_formatter.dart';
import '../../constants/encryption_services.dart';

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
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: message.msg.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            ),
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

Widget sentMessage(BuildContext context, MessageModel message) {
  // if (message.sender != AuthHelper().user!.uid) {
  //   if (message.read != null && message.read!.isEmpty) {
  //     FirebaseRequest().updateMessageReadStatus(message);
  //   }
  // }

  final decryptMessage = EncryptionService().decryptMessage(message.msg.toString());
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
                                style: customTextStyle(fontSize: 14, color: Colors.white),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: message.msg.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image, size: 70),
                                ),
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
        return ListView(
          shrinkWrap: true,
          children: [
            //black divider
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              // decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)),
            ),

            message.type == Type.text
                ?
                //copy option
                ChatOptions(
                    icon: const Icon(Icons.copy_all_rounded, color: Colors.blue, size: 26),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: message.msg.toString()))
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    })
                :
                //save option
                ChatOptions(
                    icon: const Icon(Icons.download_rounded, color: Colors.blue, size: 26),
                    name: 'Save Image',
                    onTap: () async {
                      try {
                        log('Image Url: ${message.msg}');
                        // await GallerySaver.saveImage(widget.message.msg,
                        //         albumName: 'We Chat')
                        //     .then((success) {
                        //   //for hiding bottom sheet
                        //   Navigator.pop(context);
                        //   if (success != null && success) {
                        //     Dialogs.showSnackbar(
                        //         context, 'Image Successfully Saved!');
                        //   }
                        // });
                      } catch (e) {
                        log('ErrorWhileSavingImg: $e');
                      }
                    }),

            //separator or divider
            // if (isMe)
            Divider(
              color: Colors.black54,
              endIndent: 10,
              indent: 10,
            ),

            //edit option
            if (message.type == Type.text)
              ChatOptions(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                  name: 'Edit Message',
                  onTap: () {
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    // _showMessageUpdateDialog();
                  }),

            //delete option
            // if (isMe)
            ChatOptions(
                icon: const Icon(Icons.delete_forever, color: Colors.red, size: 26),
                name: 'Delete Message',
                onTap: () async {
                  await FirebaseRequest().deleteMessage(message).then((value) {
                    //for hiding bottom sheet
                    Navigator.pop(context);
                  });
                }),

            //separator or divider
            Divider(
              color: Colors.black54,
              endIndent: 10,
              indent: 10,
            ),

            // //sent time
            // ChatOptions(
            //     icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
            //     name:
            //         'Sent At: ${DateFormatterUtils.getMessageTime(context: context, time: widget.message.sent)}',
            //     onTap: () {}),

            // //read time
            // ChatOptions(
            //     icon: const Icon(Icons.remove_red_eye, color: Colors.green),
            //     name: widget.message.read.isEmpty
            //         ? 'Read At: Not seen yet'
            //         : 'Read At: ${DateFormatterUtils.getMessageTime(context: context, time: widget.message.read)}',
            //     onTap: () {}),
          ],
        );
      });
}

class ChatOptions extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const ChatOptions({required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style:
                        const TextStyle(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)))
          ]),
        ));
  }
}
