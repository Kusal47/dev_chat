import 'package:dev_chat/features/auth/register/presentation/register_screen.dart';
import 'package:dev_chat/features/chats/presentation/chat_conversation_screen.dart';
import 'package:dev_chat/features/chats/presentation/chat_setting.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/presentation/dashboard_screen.dart';
import 'package:dev_chat/features/search/presentation/search_screen.dart';
import 'package:dev_chat/features/splash_screen/presentation/onboard_screen.dart';
import 'package:get/get.dart';

import '../../features/auth/forget_password/presentation/forget_password.dart';
import '../../features/auth/login/presentation/login_screen.dart';
import '../../features/dashboard/presentation/home_screen/presentation/home_screen.dart';
import '../../features/splash_screen/presentation/splash_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: SplashScreen.new,
    ),
    GetPage(
      name: _Paths.dashboard,
      page: DashboardScreen.new,
    ),
    GetPage(
      name: _Paths.login,
      page: LoginScreen.new,
    ),
    GetPage(
      name: _Paths.register,
      page: RegisterScreen.new,
    ),
    GetPage(
      name: _Paths.chat,
      page: () => ChatConversationScreen(
        user: Get.arguments,
      ),
      arguments: Get.arguments,
    ),
    GetPage(
      name: _Paths.forgetPassword,
      page: ForgetPassword.new,
    ),
    GetPage(
      name: _Paths.onBoardScreen,
      page: OnboardingScreen.new,
    ),
    GetPage(
      name: _Paths.searchScreen,
      page: () => SearchScreen(
        userLists: Get.arguments,
      ),
    ),
    GetPage(
      name: _Paths.chatSettings,
      page: () => ChatUserInfo(
        user: Get.arguments,
      ),
      arguments: Get.arguments,
    ),
    // GetPage(
    //   name: _Paths.login,
    //   page: LoginScreen.new,
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 1000),
    // ),
  ];
}
