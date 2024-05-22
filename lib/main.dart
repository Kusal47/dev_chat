import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/api/core_bindings.dart';
import 'core/resources/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'features/auth/login/login_screen.dart';
import 'package:device_preview/device_preview.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Garage',
      useInheritedMediaQuery: true,
      initialBinding: CoreBindings(),
      supportedLocales: const [
        Locale('en', 'US'),
        // Locale('ne', 'np'),
      ],
      fallbackLocale: const Locale('en'),

      // locale: DevicePreview.locale(context),
      locale: const Locale('en'),
      builder: (context, child) {
        final previewChild = DevicePreview.appBuilder(context, child);

        return previewChild;
      },
      home: const LoginScreen(),
      themeMode: ThemeMode.light,
      theme: AppThemes.lightThemeData,
      darkTheme: AppThemes.darkThemeData,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
