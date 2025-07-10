import 'dart:ui';

import 'package:dev_chat/core/widgets/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../resources/colors.dart';
import '../../resources/ui_assets.dart';

void showDialogBox(
  BuildContext context,
  void Function() onPressed, {
  String? description,
}) {
  showDialog(
      context: context,
      builder: (_) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(),
              ),
            ),
            SizedBox(
              height: Get.height * 0.5,
              width: Get.width * 0.9,
              child: AlertDialog(
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                actionsPadding: EdgeInsets.zero,
                title: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    height: 100,
                    child: SvgPicture.asset(
                      UIAssets.appLogo,
                      height: 100,
                    ),
                  ),
                ),
                content: Text(
                  description ?? '',
                  style: TextStyle(fontSize: 18, color: blackColor, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PrimaryButton(
                            radius: 10,
                            backgroundColor: Colors.redAccent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: "No",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PrimaryButton(
                            radius: 10,
                            onPressed: onPressed,
                            label: "Yes",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      });
}
