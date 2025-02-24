import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/login.dart';
import '../model/support/contact_location.dart';
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
  RxList<ContactLocationModel> locations = <ContactLocationModel>[].obs;
  Rxn<LatLng> lng = Rxn();
  Rxn<String> orderId = Rxn();
  final mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    questions.value = await ProfileApi.questions();
    isExpandedList.value = List<bool>.filled(questions.length, false);
    isLoading.value = true;

    final navController = Get.find<NavigationController>();

    final user = navController.user.value;

    if (user != null) {
      emailField.text = user.email;
      nameField.text = user.firstname;
    }

    locations.addAll(
        [
          ContactLocationModel(
              title: 'Пункт самовывоза и шоу рум в СПБ',
              map: 'Санкт-Петербург, М. Пл. Александра Невского, Наб. обводного канала 14-4, оф. 130',
              wa: '8 (812) 244-91-75',
              tg: 'RAWMIDchatbot',
              lng: LatLng(59.924579, 30.380483)
          ),
          ContactLocationModel(
              title: 'Сервисный центр СПБ',
              map: 'ООО «ТехноВекторСевер»: Санкт-Петербург, ул. Звёздная, д. 16 лит. А',
              wa: '8 (812) 244-91-75',
              tg: 'RAWMIDchatbot',
              lng: LatLng(59.8357139, 30.3626816)
          ),
          ContactLocationModel(
              title: 'Пункт самовывоза и шоу рум в Москве',
              map: 'Москва, Проектируемый проезд 3723, владение 12, корпус Б, кабинет 222',
              wa: '8 (812) 244-91-75',
              tg: 'RAWMIDchatbot',
              lng: LatLng(55.6983447, 37.7152771)
          ),
          ContactLocationModel(
              title: 'Пункт самовывоза и шоу рум в Казахстане',
              map: 'Алматы, Микрорайон Думан-2, дом 13',
              wa: '8 (812) 244-91-75',
              tg: 'RAWMIDchatbot',
              lng: LatLng(43.2859666, 77.0034855)
          )
        ]
    );

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

      final api = await ProfileApi.sendForm(file.value, body);

      if (orderId.value != null) {
        body.putIfAbsent('order_id', () => orderId.value!);
      }

      if (api) {
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