import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../api/login.dart';
import '../model/profile/sernum_support.dart';
import '../model/support/contact.dart';
import '../model/support/question.dart';

class SupportController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<QuestionAnswerModel> questions = <QuestionAnswerModel>[].obs;
  final List<String> types = ['Вопросы по заказам', 'Сервисный центр', 'Оптовикам и дилерам', 'Консультации по товарам', 'Поставщикам', 'Для жалоб и предложений', 'Оплата', 'Партнёрская программа'];
  RxList isExpandedList = [].obs;
  Rxn<int> type = Rxn();
  final subjectField = TextEditingController();
  final emailField = TextEditingController();
  final nameField = TextEditingController();
  final textField = TextEditingController();
  RxBool emailValidate = false.obs;
  final formKey = GlobalKey<FormState>();
  final target = GlobalKey();
  Rxn<PlatformFile> file = Rxn();
  Rxn<String> orderId = Rxn();
  Rxn<SernumSupportModel> sernum = Rxn();
  final mapController = MapController();
  var orderIds = <String>[].obs;
  var sernums = <SernumSupportModel>[].obs;
  var contact = Rxn<ContactMapData>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    HomeApi.getContact().then((e) {
      contact.value = e;
    });

    questions.value = await ProfileApi.questions();
    isExpandedList.value = List<bool>.filled(questions.length, false);
    isLoading.value = true;

    final navController = Get.find<NavigationController>();

    final user = navController.user.value;

    if (user != null) {
      HomeApi.getOrderIds().then((e) {
        orderIds.value = e;
      });

      HomeApi.getSernumSupport().then((e) {
        sernums.value = e;
      });

      emailField.text = user.email;
      nameField.text = user.firstname;
    }

    if (Get.arguments != null) {
      type.value = int.parse('${Get.arguments['department_id']}');
      orderId.value = Get.arguments['order_id'];
      subjectField.text = 'Вопрос по заказу #${orderId.value}';

      Timer.periodic(Duration(seconds: 1), (t) {
        Scrollable.ensureVisible(
            target.currentContext!,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut
        );

        t.cancel();
      });
    }
  }

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false
    );

    if (result != null) {
      file.value = result.files.single;
    }
  }

  Future send() async {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, String> body = {
        'email': emailField.text,
        'firstname': nameField.text,
        'subject': subjectField.text,
        'text': textField.text,
        'department_id': '${(type.value ?? 0)}'
      };

      if (orderId.value != null) {
        body.putIfAbsent('order_id', () => orderId.value!);
      }

      final api = await ProfileApi.sendForm(file.value, body);

      if (api) {
        emailField.clear();
        nameField.clear();
        subjectField.clear();
        textField.clear();
        type.value = null;
        file.value = null;
        Helper.snackBar(text: 'Ваш вопрос принят');
      }
    }
  }

  Future validateEmailX(String val) async {
    if (val.isNotEmpty && EmailValidator.validate(val)) {
      final api = await LoginApi.checkEmail(val);
      emailValidate.value = !api;
    } else {
      emailValidate.value = false;
    }
  }
}