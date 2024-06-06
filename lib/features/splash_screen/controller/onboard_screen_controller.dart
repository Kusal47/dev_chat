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
    'title': "Welcome to devChat",
    'image': "https://th.bing.com/th/id/OIP.nuWvKB_Hjm54ghTEuonzJQHaGG?w=240&h=198&c=7&r=0&o=5&dpr=2&pid=1.7",
    'description': "Connect with your friends and family."
  },
  {
    'title': 'Stay Connected',
    'image': "https://th.bing.com/th/id/OIP.nuWvKB_Hjm54ghTEuonzJQHaGG?w=240&h=198&c=7&r=0&o=5&dpr=2&pid=1.7",
    'description': 'Stay in touch with people no matter where you are.'
  },
  {
    'title': 'Secure and Private',
    'image': "https://th.bing.com/th/id/OIP.nuWvKB_Hjm54ghTEuonzJQHaGG?w=240&h=198&c=7&r=0&o=5&dpr=2&pid=1.7",
    'description': 'Your privacy is our top priority.',
  }
];
