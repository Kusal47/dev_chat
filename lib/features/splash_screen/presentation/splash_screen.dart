import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/storage_constants.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/secure_storage_functions.dart';
import '../../../core/routes/app_pages.dart';
import '../../auth/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  SecureStorageService secureStorageService = SecureStorageService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        String? onboardCheck =
            await secureStorageService.readSecureData(StorageConstants.onboardDisplayed);

        Future.delayed(const Duration(seconds: 3), () async {
          bool? isLogin = await Get.put(AuthController()).isLogin();
          if (isLogin == true) {
            Get.offAllNamed(Routes.dashboard);
          } else if (onboardCheck == null) {
            Get.offAllNamed(Routes.onBoardScreen);
          } else {
            Get.offAllNamed(Routes.login);
          }
        });
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: RotationTransition(
            turns: _animation,
            child: CircleAvatar(
              radius: 150,
              child: SvgPicture.asset(UIAssets.appLogo,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
