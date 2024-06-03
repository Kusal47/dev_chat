import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/onboard_screen_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    Get.put(OnboardScreenController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<OnboardScreenController>(
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (int index) {
                    controller.updateIndex(index);
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                // color: const Color(0xffEFF7FF),
                                child: SvgPicture.asset(UIAssets.appLogo),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 38),
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.srcATop,
                                  ),
                                  child: SvgPicture.asset(onboardingData[i]['image']),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            onboardingData[i]['title'],
                            style: const TextStyle(
                                color: blackColor, fontSize: 20, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Text(
                              onboardingData[i]['description'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w200, color: blackColor),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => buildDot(index, context)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: PrimaryButton(
                radius: 10,
                label:
                    controller.currentIndex == onboardingData.length - 1 ? "Get Started" : "Next",
                onPressed: () async {
                  if (controller.currentIndex == onboardingData.length - 1) {
                    controller.setOnboardScreen();
                    Navigator.pushReplacementNamed(context, Routes.login);
                  }
                  controller.pageController.nextPage(
                      duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
                },
              ),
            ),
          ],
        );
      },
    ));
  }
}

Widget buildDot(int index, BuildContext context) {
  return GetBuilder<OnboardScreenController>(builder: (controller) {
    return Container(
      height: 10,
      width: index == controller.currentIndex ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: index == controller.currentIndex ? const Color(0xFF642CDA) : Colors.grey,
      ),
    );
  });
}
