import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/api/network_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..put(const FlutterSecureStorage(), permanent: true)
      ..put(Dio(), permanent: true)
      ..put(InternetConnectionChecker(), permanent: true)
      ..put<NetworkInfo>(
          NetworkInfoImpl(dataConnectionChecker: Get.find<InternetConnectionChecker>()),
          permanent: true)
    ..put(AuthHelper(), permanent: true);
  }
}
