import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/navigation.dart';
import '../../utils/helper.dart';
import '../api/login.dart';
import '../model/profile/profile.dart';

class LoginController extends GetxController {
  RxBool valid = false.obs;
  RxBool isPasswordVisible = false.obs;
  final TextEditingController emailField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  RxString verificationCode = ''.obs;
  final navController = Get.find<NavigationController>();
  RxBool validateEmail = false.obs;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future login() async {
    if (valid.value) {
      Helper.closeKeyboard();

      final user = await LoginApi.login({
        'email': emailField.text,
        'password': passwordField.text
      });

      if (user != null) {
        navController.user.value = user;
        update();

        final param = Get.parameters;

        if ((param['route'] ?? '').isNotEmpty) {
          Get.toNamed('/${param['route']}');
          return;
        }

        Get.offAllNamed('home');
      }
    }
  }

  Future<ProfileModel?> getUser() async {
    return await ProfileApi.user();
  }

  Future loginCode() async {
    if (valid.value && verificationCode.isNotEmpty && verificationCode.value.length == 4) {
      Helper.closeKeyboard();

      final user = await LoginApi.loginCode({
        'email': emailField.text,
        'code': verificationCode.value
      });

      if (user != null) {
        navController.user.value = user;
        update();

        final param = Get.parameters;

        if ((param['route'] ?? '').isNotEmpty) {
          Get.toNamed('/${param['route']}');
          return;
        }

        Get.offAllNamed('home');
      }
    }
  }

  Future sendCode() async {
    if (emailField.text.isNotEmpty && EmailValidator.validate(emailField.text)) {
      Helper.closeKeyboard();

      final register = await LoginApi.sendCode(emailField.text);

      if (register) {
        final param = Get.parameters;
        Map<String, String> newParam = {};

        if ((param['route'] ?? '').isNotEmpty) {
          newParam = {'route': param['route']!};
        }

        Get.toNamed('/login_code', parameters: newParam);
      } else {
        Helper.snackBar(error: true, text: 'Ошибка отправки кода');
      }
    } else {
      Helper.snackBar(error: true, text: 'Заполните E-mail');
    }
  }

  Future validate() async {
    valid.value = emailField.text.isNotEmpty && EmailValidator.validate(emailField.text) && passwordField.text.isNotEmpty;
  }

  Future validateEmailX() async {
    if (emailField.text.isNotEmpty && EmailValidator.validate(emailField.text)) {
      final api = await LoginApi.checkEmail(emailField.text);
      validateEmail.value = !api;
    } else {
      validateEmail.value = false;
    }
  }
}