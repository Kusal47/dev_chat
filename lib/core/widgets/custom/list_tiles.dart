import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/widgets/common/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTilesCustom extends StatelessWidget {
  const ListTilesCustom({
    super.key,
    this.text,
    this.leadingWidget,
    this.onTap,
  });
  final String? text;
  final Widget? leadingWidget;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingWidget,
      title: Text(text ?? ''),
      onTap: onTap,
    );
  }
}

class ListTilesWidget extends StatelessWidget {
  const ListTilesWidget({
    super.key,
    this.title,
    this.onTap,
    this.subtitle,
    this.trailingtitle,
    this.radius,
    this.icon,
    this.bgColor,
    this.iconColor,
    this.textcolor,
    this.fontSize,
    this.fontWeight,
    this.textbaseline,
    this.fontStyle,
    this.textOverflow,
    this.trailIcon,
    this.dateTime,
    this.image,
    this.onAddUser,
  });
  final String? title;
  final String? subtitle;
  final String? trailingtitle;
  final String? dateTime;
  final Function()? onTap;
  final Function()? onAddUser;
  final double? radius;
  final IconData? icon;
  final IconData? trailIcon;
  final Color? bgColor;
  final Color? iconColor;
  final Color? textcolor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextBaseline? textbaseline;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: image != null && image!.isNotEmpty
          ? CustomCachedImage(
              height: 60,
              width: 60,
              imageUrl: image.toString(),
            )
          : const CircleAvatar(
              radius: 30,
              child: Icon(
                CupertinoIcons.person,
                size: 70,
              )),
      title: Text(title ?? "",
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.bold,
            color: textcolor ?? primaryColor,
            // textBaseline: textbaseline??TextBaseline.alphabetic,
            fontStyle: fontStyle ?? FontStyle.normal,
            overflow: textOverflow ?? TextOverflow.ellipsis,
          )),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(subtitle ?? "",
                style: TextStyle(
                  fontSize: fontSize ?? 12,
                  fontWeight: fontWeight ?? FontWeight.normal,
                  color: textcolor ?? primaryColor,
                  // textBaseline: textbaseline??TextBaseline.alphabetic,
                  fontStyle: fontStyle ?? FontStyle.normal,
                  overflow: textOverflow ?? TextOverflow.ellipsis,
                )),
          ),
          Text(dateTime ?? "",
              style: TextStyle(
                fontSize: fontSize ?? 12,
                fontWeight: fontWeight ?? FontWeight.normal,
                color: textcolor ?? primaryColor,
                // textBaseline: textbaseline??TextBaseline.alphabetic,
                fontStyle: fontStyle ?? FontStyle.normal,
                overflow: textOverflow ?? TextOverflow.ellipsis,
              )),
        ],
      ),
      trailing: trailIcon != null
          ? GestureDetector(onTap: onAddUser, child: Icon(trailIcon))
          : Text(trailingtitle ?? "",
              style: TextStyle(
                fontSize: fontSize ?? 14,
                fontWeight: fontWeight ?? FontWeight.normal,
                color: textcolor ?? primaryColor,
                // textBaseline: textbaseline??TextBaseline.alphabetic,
                fontStyle: fontStyle ?? FontStyle.normal,
                overflow: textOverflow ?? TextOverflow.ellipsis,
              )),
    );
  }
}
