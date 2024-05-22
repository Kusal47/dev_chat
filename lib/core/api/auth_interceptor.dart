import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as g;

import '../constants/storage_constants.dart';
import '../resources/secure_storage_functions.dart';
import '../routes/app_pages.dart';
import '../widgets/common/toast.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final FlutterSecureStorage storage;

  AuthInterceptor(this._dio, this.storage);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path.contains("login")) {
        showErrorToast("Invalid credentials. Please try again");
      } else {
        logout();
      }
    } else if (err.response?.statusCode == 429) {
      // showErrorToast("Too Many Requests. Please try again later");
      // Stop the API call
      handler.reject(err);
    } else {
      return handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['requiresToken'] == false) {
      return handler.next(options);
    } else {
      final accessToken = await storage.read(key: StorageConstants.accessToken);
      if (options.headers['allowInvalid'] == true) {
        options.headers.addAll(
          <String, String>{'Authorization': 'Bearer $accessToken'},
        );
        return handler.next(options);
      } else {
        if (accessToken == null) {
          final error = DioError(
            requestOptions: options,
            type: DioErrorType.badResponse,
            response: Response(requestOptions: options, statusMessage: "Unauthorized"),
          );

          return handler.reject(error);
        }
        options.headers.addAll(
          <String, String>{'Authorization': 'Bearer $accessToken'},
        );
        return handler.next(options);
      }
    }
  }

  SecureStorageService secureStorageService = SecureStorageService();

  void logout() async {
    showErrorToast(
      "Token expired. Please login again",
    );

    await secureStorageService.deleteSecureData(StorageConstants.accessToken);
    await secureStorageService.deleteSecureData(StorageConstants.saveUserData);
    await secureStorageService.deleteSecureData(StorageConstants.userEmail);
    g.Get.offNamedUntil(Routes.login, (route) => false);
    return;
  }
}
