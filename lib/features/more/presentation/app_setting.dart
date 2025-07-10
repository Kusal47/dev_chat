import 'dart:developer';
import 'dart:io';
import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/cached_network_image.dart';
import 'package:dev_chat/core/widgets/common/custom_widget.dart';
import 'package:dev_chat/features/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/constants/encryption_services.dart';
import '../../../core/resources/colors.dart';
import '../../../core/widgets/common/base_widget.dart';
import '../../../core/widgets/common/show_dialog_box.dart';
import '../../../core/widgets/custom/list_tiles.dart';
import '../../auth/controller/auth_controller.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../dashboard/presentation/home_screen/controller/home_controller.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  @override
  void initState() {
    Get.put(AuthController());
    Get.put(ProfileController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return BaseWidget(builder: (context, config, theme) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        log(profileController.user.value.image.toString());
        final decryptedImage = profileController.user.value.image != null &&
                profileController.user.value.image!.isNotEmpty
            ? EncryptionHelper().decryptData(profileController.user.value.image.toString())
            : profileController.user.value.image;
        return GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('App Settings'),
                  centerTitle: true,
                ),
                body: ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    Card(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // ThemeData().brightness == Brightness.light
                                    //     ? Icon(HeroIcons.sun, color: Colors.amber, size: 30)
                                    //     : Icon(HeroIcons.moon, color: Colors.white, size: 30)

                                    IconButton(
                                      icon: profileController.isDarkMode
                                          ? Icon(HeroIcons.moon, color: Colors.white, size: 30)
                                          : Icon(HeroIcons.sun, color: Colors.amber, size: 30),
                                      onPressed: () {
                                        profileController.toggleTheme();
                                      },
                                    )
                                  ],
                                ),
                                decryptedImage != null && decryptedImage.isNotEmpty
                                    ? CustomCachedImage(
                                        imageUrl: decryptedImage.toString(),
                                        width: 100,
                                        height: 100,
                                      )
                                    : profileController.pickedImage != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Image.file(
                                                File(profileController.pickedImage!.path),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : const CircleAvatar(
                                            radius: 50,
                                            child: Icon(
                                              CupertinoIcons.person,
                                              size: 80,
                                            )),
                                Text(profileController.user.value.name ?? 'User',
                                    style: customTextStyle(
                                        color: theme.textTheme.labelLarge?.color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Text(profileController.user.value.email ?? 'useremail@gmail.com',
                                    style: customTextStyle(
                                        color: theme.textTheme.labelLarge?.color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 5,
                                ),
                              ])),
                    ),
                    ListTilesCustom(
                      leadingWidget: const Icon(Icons.edit_note),
                      text: 'Edit Profile',
                      onTap: () {
                        Get.to(() => const ProfileScreen());
                      },
                    ),
                    ListTilesCustom(
                      leadingWidget: const Icon(CupertinoIcons.doc_on_doc),
                      text: 'Privacy and Policy',
                      onTap: () {
                        // Get.to(() => ProfileScreen());
                      },
                    ),
                    ListTilesCustom(
                      leadingWidget: const Icon(Icons.info_outlined),
                      text: 'About Us',
                      onTap: () {
                        // Get.to(() => ProfileScreen());
                      },
                    ),
                    ListTilesCustom(
                      leadingWidget: const Icon(Icons.phone),
                      text: 'Contact Us',
                      onTap: () {
                        // Navigator.pop(context);
                      },
                    ),
                    ListTilesCustom(
                      leadingWidget: const Icon(Icons.block_flipped),
                      text: 'Blocked List',
                      onTap: () {
                        Get.toNamed(Routes.blockedUser);
                        // Get.to(() => BlockedUserListScreen());
                      },
                    ),
                    ListTilesCustom(
                      leadingWidget: const Icon(Icons.logout),
                      text: 'LogOut',
                      onTap: () {
                        showDialogBox(
                          context,
                          () async {
                            authController.logout(context);
                            await FirebaseRequest().updateActiveStatus(false);
                          },
                          description: "Oh no! you’re leaving...\nAre you Sure?",
                        );
                      },
                    ),
                  ],
                ),
              );
            });
      });
    });
  }
}
