import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_chat/core/constants/validators.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/core/widgets/common/buttons.dart';
import 'package:dev_chat/core/widgets/common/text_form_field.dart';
import 'package:dev_chat/features/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/capitalize_first_letters.dart';
import '../../../core/constants/encryption_services.dart';
import '../model/update_params.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Get.put(ProfileController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UpdateParams updateParams = UpdateParams();

    return GetBuilder<ProfileController>(builder: (controller) {
      final decryptedImage =
          controller.user.value.image != null && controller.user.value.image!.isNotEmpty
              ? EncryptionHelper().decryptData(controller.user.value.image.toString())
              : controller.user.value.image;
      // final decryptedImage = EncryptionHelper().decryptData(controller.user.value.image.toString());
      return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: BaseWidget(builder: (context, config, theme) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Profile Screen'),
                automaticallyImplyLeading: false,
                leading: InkWell(
                    onTap: () {
                      // Get.offAllNamed(Routes.dashboard);
                      controller.loadUserData();
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)),
              ),
              body: Form(
                key: controller.formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            controller.pickedImage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        File(controller.pickedImage!.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: decryptedImage != null && decryptedImage.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              imageUrl: decryptedImage,
                                              placeholder: (context, url) => const CircleAvatar(
                                                  child: Icon(CupertinoIcons.person)),
                                              errorWidget: (context, url, error) =>
                                                  const CircleAvatar(
                                                      child: Icon(CupertinoIcons.person)),
                                            ))
                                        : const CircleAvatar(
                                            radius: 50,
                                            child: Icon(
                                              CupertinoIcons.person,
                                              size: 80,
                                            )),
                                  ),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.pickImage(context);
                                  },
                                  child: const CircleAvatar(
                                    radius: 10,
                                    child: Icon(
                                      Icons.camera_alt_sharp,
                                      size: 12,
                                    ),
                                  ),
                                ))
                          ],
                        ),

                        SizedBox(height: Get.height * .05),

                        PrimaryFormField(
                          hintIcon: _buildFormFieldIcon(
                            Icons.person_outline,
                            theme.primaryColor,
                          ),
                          labelTxt: 'Name',
                          onSaved: (value) {
                            final capitalizedValue = capitalizeFirstLetters(value);
                            updateParams.name = capitalizedValue;
                          },
                          initialValue: controller.user.value.name,
                          validator: Validators.checkFieldEmpty,
                          prefixIcon: const Icon(Icons.person, color: Colors.blue),
                        ),
                        SizedBox(height: Get.height * .02),
                        PrimaryFormField(
                          hintIcon: _buildFormFieldIcon(
                            Icons.person_outline,
                            theme.primaryColor,
                          ),
                          labelTxt: 'Username',
                          onSaved: (value) {
                            updateParams.username = value;
                          },
                          initialValue: controller.user.value.username,
                          validator: Validators.checkFieldEmpty,
                          prefixIcon: const Icon(Icons.person, color: Colors.blue),
                        ),
                        SizedBox(height: Get.height * .02),
                        PrimaryFormField(
                          hintIcon: _buildFormFieldIcon(
                            Icons.email,
                            theme.primaryColor,
                          ),
                          labelTxt: 'Email',
                          onSaved: (value) {
                            updateParams.email = value;
                          },
                          initialValue: controller.user.value.email,
                          validator: Validators.checkEmailField,
                        ),
                        SizedBox(height: Get.height * .02),
                        // PrimaryFormField(
                        //   hintIcon: _buildFormFieldIcon(Icons.person_outline, theme.primaryColor),
                        //   labelTxt: 'Username',
                        //   onSaved: (value) {},
                        //   initialValue: "Kusal Aryal",
                        //   validator: Validators.checkFieldEmpty,
                        //   prefixIcon: const Icon(Icons.person, color: Colors.blue),
                        // ),

                        PrimaryFormField(
                          hintIcon: _buildFormFieldIcon(Icons.info_outline, theme.primaryColor),
                          labelTxt: 'About',
                          onSaved: (value) {
                            updateParams.about = value;
                          },
                          initialValue: controller.user.value.about,
                          validator: Validators.checkFieldEmpty,
                        ),

                        // for adding some space
                        SizedBox(height: Get.height * .05),
                        PrimaryButton(
                            label: 'UPDATE',
                            onPressed: () {
                              final currentState = controller.formKey.currentState;
                              if (currentState != null) {
                                currentState.save();

                                if (currentState.validate()) {
                                  controller.updateUserData(context, updateParams);
                                }
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ));
        }),
      );
    });
  }

  Icon _buildFormFieldIcon(IconData iconData, color) {
    return Icon(
      iconData,
      color: color,
      size: 25,
    );
  }
}
