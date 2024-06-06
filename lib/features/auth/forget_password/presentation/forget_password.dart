import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/validators.dart';
import '../../../../core/resources/appbar_widget.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/ui_assets.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../core/widgets/common/base_widget.dart';
import '../../../../core/widgets/common/buttons.dart';
import '../../../../core/widgets/common/text_form_field.dart';
import '../controller/forget_password_controller.dart';
import '../model/forget_password_params.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  void initState() {
    Get.put(ForgetPasswordController());
    super.initState();
  }

  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final ForgotPasswordParams _forgotPasswordParams = ForgotPasswordParams();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        appTitle: "Back",
      ),
      body: GetBuilder<ForgetPasswordController>(
          // init: ForgetPasswordController(),
          builder: (c) {
        return BaseWidget(builder: (context, config, theme) {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: config.appHorizontalPaddingMedium(),
                ),
                child: Form(
                  key: _forgotPasswordFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: SvgPicture.asset(UIAssets.appLogo),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Forgot Password ?",
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
                        keyboardType: TextInputType.emailAddress,
                        hintTxt: "Email Address",
                        onSaved: (value) {
                          _forgotPasswordParams.email = value;
                        },
                        onChanged: (value) {
                          _forgotPasswordParams.email = value;
                        },
                      ),
                      config.verticalSpaceMedium(),
                      PrimaryButton(
                        onPressed: () {
                          final currentState = _forgotPasswordFormKey.currentState;
                          if (currentState != null) {
                            currentState.save();

                            if (currentState.validate()) {
                              c.resetEmail(context, _forgotPasswordParams.email.toString());
                            }
                          }
                        },
                        label: "Proceed",
                      ),
                      config.verticalSpaceMedium(),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account?',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(color: blackColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Login.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAllNamed(Routes.login);
                                },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
      }),
    );
  }
}
