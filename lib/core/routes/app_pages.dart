import 'package:get/get.dart';

import '../../features/dashboard/home_screen/home_screen.dart';
import '../../features/splash_screen/splash_screen.dart';
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
      page: HomeScreen.new,
    ),
    // GetPage(
    //   name: _Paths.login,
    //   page: LoginScreen.new,
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 1000),
    // ),
     ];
}
