import 'dart:developer';

import 'package:get/get.dart';

class Validators {
  static String? checkFieldEmpty(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? checkPhoneField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } else if (!(fieldContent.isNumericOnly && fieldContent.length == 10)) {
      return 'Invalid phone number';
    } else if (fieldContent.length > 10) {
      return 'number must be above 10 digits ';
    }

    return null;
  }

  static String? checkAmountField(String? fieldContent) {
    fieldContent!.trim();
    int? amount = int.tryParse(fieldContent);
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } 
    else if (amount == null || amount > 2000) {
      return 'Amount must not exceed 2000';
    }

    return null;
  }

  static String? checkPasswordField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } else if (fieldContent.length < 8) {
      return 'The password should be at least 8 digits';
    }

    return null;
  }

  static String? checkConfirmPassword(String? password, String? fieldContent) {
    var checkPassword = checkPasswordField(fieldContent);
    if (checkPassword != null) {
      return checkPassword;
    }

    if (password != fieldContent!) {
      log("The passwords are  $password ====> $fieldContent");
      return "Password does not match";
    }
    return null;
  }

  static String? checkEmailField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } else if (!GetUtils.isEmail(fieldContent.trim())) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? checkOptionalEmailField(String? fieldContent) {
    fieldContent!.trim();
    if ((fieldContent.isNotEmpty) && !GetUtils.isEmail(fieldContent)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? checkPinField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } else if (!(fieldContent.isNumericOnly && fieldContent.length == 5)) {
      return 'Invalid OTP';
    }
    return null;
  }
}
