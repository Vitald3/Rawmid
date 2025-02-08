import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/login.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (controller) => Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    titleSpacing: 20,
                    leadingWidth: 0,
                    leading: SizedBox.shrink(),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: Get.back,
                              child: Image.asset('assets/icon/left.png')
                          ),
                          Image.asset('assets/image/logo.png', width: 70)
                        ]
                    )
                ),
                backgroundColor: Colors.transparent,
                body: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/image/login_back.png'), fit: BoxFit.cover)
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Container(
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Вход',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                    ),
                                    h(10),
                                    Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                                    h(20),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Адрес электронной почты', style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.28
                                          )),
                                          h(4),
                                          TextFormField(
                                              controller: controller.emailField,
                                              decoration: decorationInput(hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (val) {
                                                if ((val ?? '').isEmpty) {
                                                  return 'Заполните E-mail';
                                                } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                                                  return 'E-mail некорректен';
                                                }

                                                return null;
                                              },
                                              onChanged: (val) => controller.validate()
                                          )
                                        ]
                                    ),
                                    h(16),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Пароль', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          h(4),
                                          TextFormField(
                                              controller: controller.passwordField,
                                              obscureText: controller.isPasswordVisible.value,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              decoration: decorationInput(hint: 'Введите пароль', suffixIcon: IconButton(
                                                  icon: Icon(controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                                                  onPressed: () => controller.isPasswordVisible.value = !controller.isPasswordVisible.value
                                              )),
                                              onChanged: (val) => controller.validate(),
                                              validator: (val) {
                                                if ((val ?? '').isEmpty) {
                                                  return 'Заполните пароль';
                                                }

                                                return null;
                                              }
                                          )
                                        ]
                                    ),
                                    h(20),
                                    PrimaryButton(
                                        text: 'Войти по коду',
                                        loader: true,
                                        height: 40,
                                        borderRadius: 8,
                                        background: Colors.white,
                                        borderColor: primaryColor,
                                        loaderColor: primaryColor,
                                        borderWidth: 2,
                                        textStyle: TextStyle(color: primaryColor),
                                        onPressed: controller.sendCode
                                    ),
                                    h(6),
                                    PrimaryButton(
                                        text: 'Войти',
                                        loader: true,
                                        disable: !controller.valid.value,
                                        height: 40,
                                        borderRadius: 8,
                                        onPressed: controller.login
                                    ),
                                    h(24),
                                    Center(
                                        child: Text(
                                            'Еще нет аккаунта?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF8A95A8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.24
                                            )
                                        )
                                    ),
                                    Center(
                                        child: TextButton(
                                            onPressed: () => Get.offNamed('login'),
                                            child: Text('Зарегистрироваться', style: TextStyle(color: Colors.blue))
                                        )
                                    )
                                  ]
                              )
                          ))
                        ]
                    )
                )
            )
        )
    );
  }
}