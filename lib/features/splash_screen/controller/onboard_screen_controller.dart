import 'package:dev_chat/core/resources/secure_storage_functions.dart';
import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/storage_constants.dart';

class OnboardScreenController extends GetxController {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;

  SecureStorageService secureStorageService = SecureStorageService();

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    update();
  }

   setOnboardScreen() async {
    await secureStorageService.writeSecureData(StorageConstants.onboardDisplayed, "true");
  }
}

List onboardingData = [
  {
    'title': "Welcome to ChatApp",
    'image': UIAssets.appLogo,
    'description': "Connect with your friends and family."
  },
  {
    'title': 'Stay Connected',
    'image': UIAssets.appLogo,
    'description': 'Stay in touch with people no matter where you are.'
  },
  {
    'title': 'Secure and Private',
    'image': UIAssets.appLogo,
    'description': 'Your privacy is our top priority.',
  }
];
