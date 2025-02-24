import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/cart.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/cart.dart';
import 'package:rawmid/controller/wishlist.dart';
import 'package:rawmid/model/city.dart';
import 'package:rawmid/model/location.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../api/product.dart';
import '../model/cart.dart';
import '../model/home/news.dart';
import '../model/home/product.dart';
import '../model/profile/profile.dart';
import '../screen/cart/cart.dart';
import '../screen/catalog/catalog.dart';
import '../screen/home/home.dart';
import '../screen/wishlist/wishlist.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
    const CatalogView(),
    const SizedBox(),
    const WishlistView(),
    const CartView()
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
  RxString searchCity = ''.obs;
  RxList<CityModel> filteredCities = <CityModel>[].obs;
  RxList<Location> filteredLocation = <Location>[].obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  RxList<CartModel> cartProducts = <CartModel>[].obs;
  RxList<ProductModel> searchProducts = <ProductModel>[].obs;
  RxList<NewsModel> searchNews = <NewsModel>[].obs;
  late stt.SpeechToText speech;
  RxBool isListening = false.obs;
  RxBool isAvailable = false.obs;
  RxString searchText = ''.obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;

  onItemTapped(int index) {
    if (index == 3 && activeTab.value != 3) {
      final wishlistController = Get.find<WishlistController>();
      wishlistController.initialize();
    }

    activeTab.value = index;
  }

  void resetV() {
    reset.value = true;
  }

  Future filterCities(String val) async {
    searchCity.value = val;

    if (val.isNotEmpty) {
      final query = val.toLowerCase();
      final api = await HomeApi.searchCity(query);
      filteredLocation.value = api;
      filteredCities.value = [];
    } else {
      filteredLocation.value = [];
      filteredCities.value = cities;
    }
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
    await loadJsonFromAssets();
    filteredCities.value = cities;

    speech = stt.SpeechToText();

    bool available = await speech.initialize(
        onStatus: (status) {
          isListening.value = status == 'listening';

          if (status == 'done') {
            search(searchText.value);
          }
        },
        onError: (error) => debugPrint('Ошибка: $error')
    );

    if (available) {
      isAvailable.value = true;
    }
  }

  Future addCart(String id) async {
    final api = await CartApi.addCart({
      'product_id': id
    });
    cartProducts.value = api;

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      cart.cartProducts.value = api;
      cart.update();
    }
  }

  Future clear() async {
    await CartApi.clear();
    cartProducts.value = [];

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      cart.cartProducts.value = [];
      cart.update();
    }
  }

  Future<bool> addChainCart(Map<String, dynamic> body) async {
    final api = await ProductApi.addChainCart(body);
    cartProducts.value = api;
    final cart = Get.find<CartController>();
    cart.cartProducts.value = api;
    cart.update();
    return api.isNotEmpty;
  }

  Future search(String val) async {
    searchText.value = val;

    if (val.isEmpty) {
      searchProducts.clear();
      searchNews.clear();
      return;
    }

    final api = await HomeApi.search(val);

    if (api != null) {
      searchProducts.value = api.products;
      searchNews.value = api.news;
    }
  }

  clearSearch() {
    searchProducts.clear();
    searchNews.clear();
    searchText.value = '';
    Helper.closeKeyboard();
  }

  Future<void> startListening() async {
    if (isAvailable.value) {
      isListening.value = true;

      speech.listen(
          onResult: (result) {
            searchText.value = result.recognizedWords;
          }
      );
    }
  }

  void stopListening() {
    speech.stop();
    isListening.value = false;
  }

  Future loadJsonFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/city.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    for (var i in jsonData) {
      cities.add(CityModel.fromJson(i));
    }
  }

  Future logout() async {
    ProfileApi.logout();
    user.value = null;
    Helper.prefs.setString('PHPSESSID', '');
    Get.back();
  }
}