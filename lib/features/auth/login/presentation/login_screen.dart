import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/features/auth/login/model/login_params.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/constants/validators.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/ui_assets.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../core/widgets/common/buttons.dart';
import '../../../../core/widgets/common/text_form_field.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginParams loginParams = LoginParams();
    final _loginFormKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        body: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (c) {
              return SingleChildScrollView(
                child: BaseWidget(builder: (context, config, theme) {
                  return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: config.appHorizontalPaddingMedium(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // config.verticalSpaceMedium(),
                          SizedBox(
                            // color: Colors.red,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: SvgPicture.asset(UIAssets.appLogo),
                          ),
                          Form(
                            key: _loginFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Log in",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 24, color: blackColor),
                                  ),
                                ),
                                config.verticalSpaceMedium(),
                                PrimaryFormField(
                                  // isPassword: true,
                                  validator: Validators.checkEmailField,
                                  keyboardType: TextInputType.text,
                                  hintTxt: "Email Address",
                                  onSaved: (value) {
                                    loginParams.email = value;
                                  },
                                  onChanged: (value) {
                                    loginParams.email = value;
                                  },
                                ),
                                config.verticalSpaceMedium(),
                                PrimaryFormField(
                                  isPassword: true,
                                  validator: Validators.checkFieldEmpty,
                                  hintTxt: "Password",
                                  onSaved: (value) {
                                    loginParams.password = value;
                                  },
                                  onChanged: (value) {
                                    loginParams.password = value;
                                  },
                                ),
                                config.verticalSpaceMedium(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.forgetPassword);
                                    },
                                    child: Text("Forgot password ?",
                                        style: Theme.of(context).textTheme.titleSmall),
                                  ),
                                ),
                                config.verticalSpaceMedium(),
                                PrimaryButton(
                                  onPressed: () {
                                    // Get.offAllNamed(Routes.dashboard);

                                    final currentState = _loginFormKey.currentState;
                                    if (currentState != null) {
                                      currentState.save();

                                      if (currentState.validate()) {
                                        print("validate" + loginParams.email.toString());
                                        print("validate" + loginParams.password.toString());
                                        c.userLogin(context, loginParams);
                                      }
                                    }
                                  },
                                  label: "Log in",
                                ),
                                config.verticalSpaceMedium(),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: primaryColor,
                                        thickness: 0.2,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text("Or Login with",
                                          style: TextStyle(color: Colors.black, fontSize: 12)),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: primaryColor,
                                        thickness: 0.2,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                config.verticalSpaceMedium(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PrimaryOutlinedButton(
                                        title: '',
                                        onPressed: () {
                                          c.googleLogin(context);
                                        },
                                        width: 40,
                                        height: 40,
                                        icon: Icon(Bootstrap.google),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PrimaryOutlinedButton(
                                        title: '',
                                        onPressed: () {
                                          c.facebookLogin(context);
                                        },
                                        width: 40,
                                        height: 40,
                                        icon: Icon(Bootstrap.facebook),
                                      ),
                                    ),
                                  ],
                                ),
                                config.verticalSpaceSmall(),
                                RichText(
                                  text: TextSpan(
                                    text: 'Didn\'t have an account?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: blackColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' Sign Up',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(Routes.register);
                                          },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ));
                }),
              );
            }),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: RichText(
        //   text: TextSpan(
        //     text: 'Didn\'t have an account?',
        //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: blackColor),
        //     children: <TextSpan>[
        //       TextSpan(
        //         text: ' Sign Up',
        //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //               color: primaryColor,
        //               fontWeight: FontWeight.w600,
        //             ),
        //         recognizer: TapGestureRecognizer()
        //           ..onTap = () {
        //             Get.toNamed(Routes.register);
        //           },
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
