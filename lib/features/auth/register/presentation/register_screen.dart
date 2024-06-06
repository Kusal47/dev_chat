import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/capitalize_first_letters.dart';
import '../../../../core/constants/validators.dart';
import '../../../../core/resources/appbar_widget.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/widgets/common/base_widget.dart';
import '../../../../core/widgets/common/buttons.dart';
import '../../../../core/widgets/common/text_form_field.dart';
import '../../login/presentation/login_screen.dart';
import '../controller/register_controller.dart';
import '../model/register_param.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerParams = RegisterParams();

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(
          appTitle: "Back",
        ),
        body: BaseWidget(
          builder: (context, config, themeData) {
            return SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GetBuilder<RegisterController>(
                init: RegisterController(),
                builder: (c) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: config.appHorizontalPaddingMedium(),
                    ),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          config.verticalSpaceSmall(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sign up with Email & Phone number",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w400, fontSize: 25),
                            ),
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            onSaved: (String value) {
                              final capitalizedValue = capitalizeFirstLetters(value);
                              registerParams.fullname = capitalizedValue;
                              // registerParams.fullname = value;
                            },
                            hintTxt: "Full Name",
                            // textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: Validators.validateFullName,
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            onSaved: (String value) {
                              registerParams.username = value;
                            },
                            hintTxt: "Username",
                            // textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: Validators.checkFieldEmpty,
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            onSaved: (String value) {
                              registerParams.email = value;
                            },
                            hintTxt: "Email Address",
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.checkEmailField,
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            onSaved: (String value) {
                              registerParams.phonenumber = value;
                            },
                            hintTxt: "Phone Number",
                            keyboardType: TextInputType.phone,
                            validator: Validators.checkPhoneField,
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            onSaved: (String value) {
                              registerParams.address = value;
                            },
                            hintTxt: "Address",
                            // textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: Validators.checkFieldEmpty,
                          ),
                          config.verticalSpaceMedium(),
                          CustomDropdownFormField(
                            items: const ["Male", "Female", "Others"],
                            value: null,
                            hint: "Select Gender",
                            onChanged: (value) {
                              registerParams.gender = value;
                            },
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            hintTxt: "Age",
                            validator: Validators.checkFieldEmpty,
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              registerParams.age = value;
                            },
                            onChanged: (value) {
                              registerParams.age = value;
                            },
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            isPassword: true,
                            hintTxt: "Password",
                            validator: Validators.checkFieldEmpty,
                            onSaved: (value) {
                              registerParams.password = value;
                            },
                            onChanged: (value) {
                              registerParams.password = value;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryFormField(
                            keyboardType: TextInputType.text,
                            isPassword: true,
                            hintTxt: "Confirm-Password",
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return "This field is required";
                              } else if (registerParams.confirmPassword != registerParams.password)
                                // ignore: curly_braces_in_flow_control_structures
                                return "Password and confirm password don't match";
                              return null;
                            },
                            onSaved: (value) {
                              registerParams.confirmPassword = value;
                            },
                            onChanged: (value) {
                              registerParams.confirmPassword = value;
                            },
                          ),
                          config.verticalSpaceMedium(),
                          InkResponse(
                            onTap: () {},
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: primaryColor),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                  ),
                                  const Text(
                                      "  By Signing up you agree to the terms of service and privacy policy") //TODO remaining finalizing
                                ],
                              ),
                            ),
                          ),
                          config.verticalSpaceMedium(),
                          PrimaryButton(
                            width: Get.width / 2,
                            onPressed: () async {
                              final controller = Get.put(RegisterController());

                              final currentState = _registerFormKey.currentState;
                              if (currentState != null) {
                                currentState.save();
                                if (currentState.validate()) {
                                  controller.userRegistration(context, registerParams);
                                  // Get.offAllNamed(Routes.login);
                                }
                              }
                            },
                            label: "Sign up",
                          ),
                          config.verticalSpaceMedium(),
                          RichText(
                            text: TextSpan(
                                text: 'Already have an account?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: blackColor),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' Log in',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                        Get.off(() => const LoginScreen());
                                      },
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ));
  }
}
