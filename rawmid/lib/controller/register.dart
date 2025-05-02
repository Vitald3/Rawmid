import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../utils/helper.dart';
import '../api/login.dart';
import 'navigation.dart';

class RegisterController extends GetxController {
  RxBool submit = false.obs;
  RxBool valid = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isPasswordConfirmVisible = false.obs;
  final TextEditingController emailField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController confirmField = TextEditingController();
  final navController = Get.find<NavigationController>();
  RxBool validateEmail = false.obs;

  Future register() async {
    if (valid.value && !submit.value) {
      submit.value = true;
      Helper.closeKeyboard();

      final user = await LoginApi.register({
        'email': emailField.text,
        'password': passwordField.text,
        'firstname': emailField.text.split('@')[0]
      });

      if (user != null) {
        final carts = navController.cartProducts;
        navController.cartProducts.clear();

        for (var cart in carts) {
          navController.addCart(cart.id);
        }

        navController.user.value = user;
        update();

        final param = Get.parameters;

        if ((param['route'] ?? '').isNotEmpty) {
          Get.toNamed('/${param['route']}');
          return;
        }

        Get.offAllNamed('home');
      }

      submit.value = false;
    }
  }

  Future validate() async {
    valid.value = emailField.text.isNotEmpty && EmailValidator.validate(emailField.text) && passwordField.text.isNotEmpty && confirmField.text.isNotEmpty && passwordField.text == confirmField.text;
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