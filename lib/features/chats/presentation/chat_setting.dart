import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/common/custom_widget.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/encryption_services.dart';
import '../../../core/widgets/custom/custom_options_widget.dart';

class ChatUserInfo extends StatefulWidget {
  final ChatUserResponseModel user;
  const ChatUserInfo({super.key, required this.user});

  @override
  State<ChatUserInfo> createState() => _ChatUserInfoState();
}

class _ChatUserInfoState extends State<ChatUserInfo> {
  @override
  Widget build(BuildContext context) {
    final decryptedImage = widget.user.image != null && widget.user.image!.isNotEmpty
        ? EncryptionHelper().decryptData(widget.user.image.toString())
        : widget.user.image.toString();
    return BaseWidget(builder: (context, config, theme) {
      return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  config.verticalSpaceExtraLarge(),
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: decryptedImage != null && decryptedImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    imageUrl: decryptedImage,
                                    placeholder: (context, url) =>
                                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                                  ))
                              : const CircleAvatar(
                                  radius: 50,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    size: 80,
                                  )),
                        ),
                        config.verticalSpaceVerySmall(),
                        Text(
                            widget.user.name != null && widget.user.name!.isNotEmpty
                                ? widget.user.name.toString()
                                : widget.user.email.toString(),
                            style: customTextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900, color: blackColor)),
                      ],
                    ),
                  ),
                  config.verticalSpaceVerySmall(),
                  CustomOptions(
                    icon: const Icon(Icons.abc, color: Colors.red, size: 26),
                    name: 'Nicknames',
                    onTap: () {},
                  ),
                  const Divider(
                    color: dividerColor,
                    endIndent: 10,
                    indent: 10,
                  ),
                  CustomOptions(
                    icon: const Icon(Icons.share, color: Colors.red, size: 26),
                    name: 'Share contact',
                    onTap: () {},
                  ),
                  const Divider(
                    color: dividerColor,
                    endIndent: 10,
                    indent: 10,
                  ),
                  CustomOptions(
                    icon: const Icon(Icons.block, color: Colors.red, size: 26),
                    name: 'Block user',
                    onTap: () {},
                  ),
                  const Divider(
                    color: dividerColor,
                    endIndent: 10,
                    indent: 10,
                  ),
                  CustomOptions(
                    icon: const Icon(Icons.report, color: Colors.red, size: 26),
                    name: 'Report user',
                    onTap: () {},
                  ),
                  const Divider(
                    color: dividerColor,
                    endIndent: 10,
                    indent: 10,
                  ),
                ],
              ),
            ),
            Positioned(
                top: 30,
                left: 10,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: blackColor, size: 30)))
          ],
        ),
      );
    });
  }
}
