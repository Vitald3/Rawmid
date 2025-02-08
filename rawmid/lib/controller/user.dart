import 'dart:async';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/navigation.dart';
import '../model/country.dart';
import '../model/profile.dart';
import '../utils/helper.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool loadImage = false.obs;
  RxBool addressDef = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool changePassValid = false.obs;
  final TextEditingController changePasswordField = TextEditingController();
  final navController = Get.find<NavigationController>();
  Rxn<ProfileModel> user = Rxn<ProfileModel>();
  RxBool newsSubscription = false.obs;
  RxBool pushNotifications = false.obs;
  RxBool edit = false.obs;
  RxBool addAddress = false.obs;
  RxInt tab = 0.obs;
  RxInt addressId = 0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyAddress = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'telephone': TextEditingController(),
    'email': TextEditingController(),
    'lastname': TextEditingController(),
    'firstname': TextEditingController()
  };
  final Map<String, TextEditingController> controllersAddress = {
    'city': TextEditingController(),
    'postcode': TextEditingController(),
    'address_1': TextEditingController()
  };
  final Map<String, TextEditingController> controllerUr = {
    'inn': TextEditingController(),
    'company': TextEditingController(),
    'ogrn': TextEditingController(),
    'rs': TextEditingController(),
    'bank': TextEditingController(),
    'bik': TextEditingController(),
    'kpp': TextEditingController(),
    'uraddress': TextEditingController(),
    'address_buh': TextEditingController(),
    'email_buh': TextEditingController(),
    'phone_buh': TextEditingController(),
    'edo': TextEditingController()
  };
  final Map<String, String> controllerHints = {
    'inn': 'Инн *',
    'company': 'Компания *',
    'ogrn': ' ОГРН *',
    'rs': 'Номер р/с *',
    'bank': 'Банк *',
    'bik': 'БИК *',
    'kpp': 'КПП *',
    'uraddress': 'Юридический адрес *',
    'address_buh': 'Почтовый адрес организации *',
    'email_buh': 'E-mail бухгалтерии *',
    'phone_buh': '+7 (___) ___ __ __',
    'edo': 'ЭДО'
  };
  final Map<String, FocusNode> focusNodeUrAddress = {
    'inn': FocusNode(),
    'company': FocusNode(),
    'ogrn': FocusNode(),
    'rs': FocusNode(),
    'bank': FocusNode(),
    'bik': FocusNode(),
    'kpp': FocusNode(),
    'uraddress': FocusNode(),
    'email_buh': FocusNode(),
    'phone_buh': FocusNode()
  };
  final Map<String, FocusNode> focusNodeAddress = {
    'city': FocusNode(),
    'postcode': FocusNode(),
    'address_1': FocusNode()
  };
  final Map<String, FocusNode> focusNodes = {
    'telephone': FocusNode(),
    'email': FocusNode(),
    'lastname': FocusNode(),
    'firstname': FocusNode()
  };
  RxString activeField = ''.obs;
  Rxn<String> region = Rxn<String>('2760');
  RxString country = '176'.obs;
  RxList<CountryModel> countries = <CountryModel>[].obs;
  RxList<ZoneModel> regions = <ZoneModel>[].obs;
  Rxn<File> imageFile = Rxn<File>();
  final ImagePicker picker = ImagePicker();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void dispose() {
    changePasswordField.dispose();
    controllers.forEach((key, controller) => controller.dispose());
    controllersAddress.forEach((key, controller) => controller.dispose());
    controllerUr.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
    focusNodeAddress.forEach((key, focusNode) => focusNode.dispose());
    focusNodeUrAddress.forEach((key, focusNode) => focusNode.dispose());
    super.dispose();
  }

  setTab(int index) {
    tab.value = index;

    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut
    );
  }

  final Map<String, String? Function(String?)> validators = {
    'telephone': (value) {
      if (value == null || value.isEmpty) {
        return 'Введите номер телефона';
      }

      String digits = value.replaceAll(RegExp(r'\D'), '');

      if (digits.length != 11 || !digits.startsWith('7')) {
        return 'Введите корректный номер';
      }

      return null;
    },
    'email': (value) {
      if (value == null || value.isEmpty) return 'Введите email';
      return EmailValidator.validate(value) ? null : 'Некорректный email';
    },
    'firstname': (value) {
      if (value == null || value.isEmpty) return 'Введите имя';
      return null;
    },
    'lastname': (value) {
      if (value == null || value.isEmpty) return 'Введите фамилию';
      return null;
    },
    'city': (value) {
      if (value == null || value.isEmpty) return 'Заполните город';
      return null;
    },
    'address': (value) {
      if (value == null || value.isEmpty) return 'Заполните адрес';
      return null;
    },
    'inn': (value) {
      if (value == null || value.isEmpty) return 'Заполните ИНН';
      return null;
    },
    'company': (value) {
      if (value == null || value.isEmpty) return 'Заполните название компании';
      return null;
    },
    'ogrn': (value) {
      if (value == null || value.isEmpty) return 'Заполните ОГРН';
      return null;
    },
    'rs': (value) {
      if (value == null || value.isEmpty) return 'Заполните рассчетный счет';
      return null;
    },
    'bank': (value) {
      if (value == null || value.isEmpty) return 'Заполните банк';
      return null;
    },
    'bik': (value) {
      if (value == null || value.isEmpty) return 'Заполните БИК';
      return null;
    },
    'kpp': (value) {
      if (value == null || value.isEmpty) return 'Заполните КПП';
      return null;
    },
    'uraddress': (value) {
      if (value == null || value.isEmpty) return 'Заполните адрес';
      return null;
    },
    'email_buh': (value) {
      if (value == null || value.isEmpty) return 'Заполните E-mail';
      return null;
    },
    'phone_buh': (value) {
      if (value == null || value.isEmpty) {
        return 'Введите номер телефона';
      }

      String digits = value.replaceAll(RegExp(r'\D'), '');

      if (digits.length != 11 || !digits.startsWith('7')) {
        return 'Введите корректный номер';
      }

      return null;
    }
  };

  Future initialize() async {
    focusNodes.forEach((key, focusNode) {
      focusNode.addListener(() {
        activeField.value = focusNode.hasFocus ? key : '';
      });
    });

    final api = await getUser();

    if (api != null) {
      user.value = api;
      newsSubscription.value = api.subscription;
      pushNotifications.value = api.push;
      controllers['telephone']!.text = api.phone;
      controllers['firstname']!.text = api.firstname;
      controllers['lastname']!.text = api.lastname;
      controllers['email']!.text = api.email;
      controllerUr['inn']!.text = api.ur.inn;
      controllerUr['company']!.text = api.ur.company;
      controllerUr['ogrn']!.text = api.ur.oGrn;
      controllerUr['rs']!.text = api.ur.rs;
      controllerUr['bank']!.text = api.ur.bank;
      controllerUr['bik']!.text = api.ur.bik;
      controllerUr['kpp']!.text = api.ur.kpp;
      controllerUr['uraddress']!.text = api.ur.urAddress;
      controllerUr['address_buh']!.text = api.ur.addressBuh;
      controllerUr['email_buh']!.text = api.ur.emailBuh;
      controllerUr['phone_buh']!.text = api.ur.phoneBuh;
      controllerUr['edo']!.text = api.ur.edo;
      tab.value = api.type ? 1 : 0;
    } else {
      Helper.prefs.setString('PHPSESSID', '');
      ProfileApi.logout();
      Get.offAllNamed('login');
    }

    ProfileApi.countries().then((val) {
      countries.value = val;
      regions.value = countries.firstWhereOrNull((e) => e.countryId == country.value)?.zone ?? <ZoneModel>[];
    });

    isLoading.value = true;
  }

  Future setAddress(int id) async {
    addressId.value = id;
    final api = await ProfileApi.setAddress(id);

    if (api != null) {
      user.value = api;
    }
  }

  Future setCountry(String? id) async {
    if (id == null) return;
    country.value = id;
    region.value = null;
    regions.value = [];

    for (var e in countries.where((e) => e.countryId == id && (e.zone ?? []).isNotEmpty)) {
      regions.addAll(e.zone!);
    }

    if (regions.isNotEmpty) {
      region.value = regions.first.zoneId;
    }
  }

  Future delete() async {
    final api = await ProfileApi.delete();

    if (!api) {
      Helper.snackBar(error: true, text: 'Ошибка удаления аккаунта');
    } else {
      Helper.prefs.setString('PHPSESSID', '');
      Get.offAllNamed('home');
    }
  }

  Future changePass() async {
    if (changePasswordField.text.isNotEmpty) {
      final api = await ProfileApi.changePass(changePasswordField.text);

      if (!api) {
        Helper.snackBar(error: true, text: 'Ошибка смены пароля');
      } else {
        Helper.snackBar(error: true, text: 'Пароль успешно изменен');
        changePasswordField.clear();
      }
    }
  }

  Future setNewsletter(bool val) async {
    final api = await ProfileApi.setNewsletter(val);

    if (!api) {
      if (val) {
        newsSubscription.value = !val;
      }

      Helper.snackBar(error: true, text: 'Произошла ошибка, попробуйте позже');
    }
  }

  Future setPush(bool val) async {
    final api = await ProfileApi.setPush(val);

    if (!api) {
      if (val) {
        pushNotifications.value = !val;
      }

      Helper.snackBar(error: true, text: 'Произошла ошибка, попробуйте позже');
    }
  }

  newAddress() async {
    if (addAddress.value) {
      if (formKeyAddress.currentState?.validate() ?? false) {
        Map<String, dynamic> body = {};

        controllersAddress.forEach((key, controller) {
          if (controller.text.isNotEmpty) {
            body.putIfAbsent(key, () => controller.text);
          }
        });

        body.putIfAbsent('firstname', () => controllers['firstname']!.text);
        body.putIfAbsent('lastname', () => controllers['lastname']!.text);
        body.putIfAbsent('country_id', () => country.value);
        body.putIfAbsent('zone_id', () => region.value);
        body.putIfAbsent('default', () => '${addressDef.value ? 1 : 0}');

        final api = await ProfileApi.saveAddress(body);

        if (api != null) {
          user.value = api;
          addAddress.value = false;
        }
      }
    } else {
      addAddress.value = true;
      controllersAddress.forEach((key, controller) => controller.clear());
    }
  }

  Future save() async {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> body = {};
      controllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          if (key == 'telephone') {
            body.putIfAbsent(key, () => controller.text.replaceAll(' (', '').replaceAll(') ', '').replaceAll(' ', '-'));
          } else {
            body.putIfAbsent(key, () => controller.text);
          }
        }
      });
      body.putIfAbsent('customer_group_id', () => '8');
      ProfileApi.save(body);
    }
  }

  Future saveUz() async {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> body = {};
      controllerUr.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          if (key == 'telephone_buh') {
            body.putIfAbsent('telephone', () => controller.text.replaceAll(' (', '').replaceAll(') ', '').replaceAll(' ', '-'));
          } else {
            body.putIfAbsent(key, () => controller.text);
          }
        }
      });
      body.putIfAbsent('customer_group_id', () => '9');
      ProfileApi.save(body);
    }
  }

  Future<ProfileModel?> getUser() async {
    return await ProfileApi.user();
  }

  Future pickImage(ImageSource source) async {
    loadImage.value = true;
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final api = await ProfileApi.uploadImage(File(pickedFile.path));

      if (api) {
        imageFile.value = File(pickedFile.path);
      }
    }

    loadImage.value = false;
  }
}