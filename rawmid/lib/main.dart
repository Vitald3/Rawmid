import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/auth/login.dart';
import 'package:rawmid/screen/auth/login_code.dart';
import 'package:rawmid/screen/auth/register.dart';
import 'package:rawmid/screen/main.dart';
import 'package:rawmid/screen/user/user.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Helper.initialize();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: '/home',
        getPages: [
          GetPage(name: '/home', page: () => const MainView()),
          GetPage(name: '/register', page: () => const RegisterView()),
          GetPage(name: '/login', page: () => const LoginView()),
          GetPage(name: '/login_code', page: () => const LoginCodeView()),
          GetPage(name: '/user', page: () => const UserView())
        ],
        theme: theme,
        debugShowCheckedModeBanner: false,
        title: appName
    );
  }
}