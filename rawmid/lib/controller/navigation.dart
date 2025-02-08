import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/wishlist.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../model/profile.dart';
import '../screen/home/home.dart';
import '../screen/wishlist/wishlist.dart';

class NavigationController extends GetxController {
  RxInt activeTab = 0.obs;
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
    5: GlobalKey<NavigatorState>()
  };
  final List<Widget> widgetOptions = <Widget>[
    const HomeView(),
    const SizedBox(),
    const SizedBox(),
    const WishlistView(),
    const SizedBox()
  ];
  final List<String> titles = [
    'Главная',
    'Каталог',
    'Клуб',
    'Избранное',
    'Корзина'
  ];
  RxBool reset = false.obs;
  Rxn<ProfileModel> user = Rxn<ProfileModel>();
  RxString city = ''.obs;

  void onItemTapped(int index) {
    if (index == 3 && activeTab.value != 3) {
      final wishlistController = Get.find<WishlistController>();
      wishlistController.initialize();
    }

    activeTab.value = index;
  }

  void resetV() {
    reset.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    final api = await HomeApi.getCityByIP();

    if (api.isNotEmpty) {
      city.value = api;
    }

    user.value = await ProfileApi.user();
  }

  Future logout() async {
    ProfileApi.logout();
    user.value = null;
    Helper.prefs.setString('PHPSESSID', '');
    Get.back();
  }
}