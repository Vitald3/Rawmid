import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawmid/api/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant.dart';
import 'package:get/get.dart';

class Helper {
  static Future initialize() async {
    prefs = await SharedPreferences.getInstance();
    wishlist.value = Helper.prefs.getStringList('wishlist') ?? [];
  }

  static late final SharedPreferences prefs;
  static ValueNotifier<List<String>> wishlist = ValueNotifier([]);

  static void snackBar({String text = '', String title = '', String yes = 'OK', bool notTitle = false, bool error = false, bool prev = false, Function? callback, Function? callback2}) {
    showDialog(context: Get.context!, builder: (_) {
      return CupertinoAlertDialog(
        title: notTitle ? null : Text(error ? 'Ошибка' : (title != '' ? title : 'Успешно')),
        actions: [
          if (prev) CupertinoDialogAction(onPressed: () {
            Get.back();
          }, child: const Text('Отмена', style: TextStyle(color: primaryColor))),
          CupertinoDialogAction(onPressed: () {
            if (callback2 != null) {
              Get.back();
              callback2();
            } else if (callback != null) {
              Get.back();
              callback();
            } else {
              Get.back();
            }
          }, child: Text(yes, style: const TextStyle(color: firstColor))),
        ],
        content: SelectableText(text),
      );
    }).then((value) {
      if (callback != null) {
        callback();
      }
    });
  }

  static void closeKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(Get.context!).unfocus();
  }

  static String getNoun(int number, String one, String two, String three, {bool before = true}) {
    var n = number.abs();
    n %= 100;
    if (n >= 5 && n <= 20) {
      return before ? "$number $three" : three;
    }
    n %= 10;
    if (n == 1) {
      return before ? "$number $one" : one;
    }
    if (n >= 2 && n <= 4) {
      return before ? "$number $two" : two;
    }
    return before ? "$number $three" : three;
  }

  static Future launchInBrowser(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static Future openLink(String link) async {
    if (link.contains('madeindream.com')) {
      final api = await HomeApi.getUrlProduct(link);

      if (api > 0) {
        //Get.to(ProductView(id: api));
      } else {
        Helper.launchInBrowser(link);
      }
    }
  }
}