import 'package:dev_chat/core/widgets/common/buttons.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/encryption_services.dart';
import '../../resources/colors.dart';
import '../common/base_widget.dart';
import '../common/cached_network_image.dart';

class CustomCardList extends StatelessWidget {
  const CustomCardList({Key? key, required this.user, required this.onPressed}) : super(key: key);
  final ChatUserResponseModel user;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final decryptedImage = user.image != null && user.image!.isNotEmpty
        ? EncryptionHelper().decryptData(user.image.toString())
        : user.image;
    return BaseWidget(builder: (context, config, theme) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              decryptedImage != null && decryptedImage.isNotEmpty
                  ? CustomCachedImage(
                      height: 60,
                      width: 60,
                      imageUrl: decryptedImage.toString(),
                    )
                  : const CircleAvatar(
                      radius: 30,
                      child: Icon(
                        CupertinoIcons.person,
                        size: 50,
                      )),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(user.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      // textBaseline: textbaseline??TextBaseline.alphabetic,
                      fontStyle: FontStyle.normal,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: config.appHorizontalPadding(5)),
                child: PrimaryOutlinedButton(
                  title: 'Add',
                  onPressed: onPressed,
                  radius: 20,
                  icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
