import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/cart.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/cart.dart';
import 'package:rawmid/controller/compare.dart';
import 'package:rawmid/controller/wishlist.dart';
import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/model/city.dart';
import 'package:rawmid/model/location.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../api/product.dart';
import '../model/cart.dart';
import '../model/home/news.dart';
import '../model/home/product.dart';
import '../model/profile/profile.dart';
import '../screen/cart/cart.dart';
import '../screen/catalog/catalog.dart';
import '../screen/compare.dart';
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
    const CompareView(),
    const WishlistView(),
    const CartView()
  ];
  final List<String> titles = [
    'Главная',
    'Каталог',
    'Сравнение',
    'Избранное',
    'Корзина'
  ];
  RxBool reset = false.obs;
  Rxn<ProfileModel> user = Rxn<ProfileModel>();
  RxInt fId = (Helper.prefs.getInt('fias_id') ?? 0).obs;
  RxString city = (Helper.prefs.getString('city') ?? '').obs;
  RxString countryCode = (Helper.prefs.getString('countryCode') ?? '').obs;
  RxString searchCity = ''.obs;
  RxList<CityModel> filteredCities = <CityModel>[].obs;
  RxList<Location> filteredLocation = <Location>[].obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  RxList<CartModel> cartProducts = <CartModel>[].obs;
  RxList<ProductModel> searchProducts = <ProductModel>[].obs;
  RxList<CategoryModel> searchCategories = <CategoryModel>[].obs;
  RxList<NewsModel> searchNews = <NewsModel>[].obs;
  late stt.SpeechToText speech;
  RxBool isListening = false.obs;
  RxBool isAvailable = false.obs;
  RxBool isSearch = false.obs;
  RxString searchText = ''.obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;

  onItemTapped(int index) {
    searchProducts.clear();
    searchNews.clear();
    searchCategories.clear();

    if (index == 3 && activeTab.value != 3) {
      final wishlistController = Get.find<WishlistController>();
      wishlistController.initialize();
    } else if (index == 2 && activeTab.value != 2) {
      final compareController = Get.find<CompareController>();
      compareController.initialize();
    }

    activeTab.value = index;
  }

  void resetV() {
    reset.value = true;
  }

  Future changeCity(CityModel val) async {
    final code = await HomeApi.changeCity(val.id);
    countryCode.value = code;
    Helper.prefs.setString('city', val.name);
    Helper.prefs.setInt('fias_id', val.id);
    Helper.prefs.setString('countryCode', code);
    Get.back();
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
    if (city.isEmpty) {
      if (Get.arguments != null) {
        city.value = Get.arguments['city'] ?? '';
        countryCode.value = Get.arguments['countryCode'] ?? 'KZ';
      } else {
        final api = await HomeApi.getCityByIP();

        if (api.isNotEmpty) {
          city.value = api['city'] ?? '';
          countryCode.value = api['countryCode'] ?? 'KZ';
        }
      }
    } else if (fId.value > 0) {
      await HomeApi.changeCity(fId.value);
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
    if (Get.currentRoute != '/ProductView') {
      final colors = await CartApi.getColors(id);

      if (colors) {
        Get.to(() => ProductView(id: id));
        return;
      }
    }


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

  bool isCart(String id) {
    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      return cart.cartProducts.where((e) => e.id == id).isNotEmpty;
    }

    return false;
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
    if (!isSearch.value) {
      if (val.isEmpty) {
        searchProducts.clear();
        searchNews.clear();
        searchCategories.clear();
        return;
      }

      final api = await HomeApi.search(val);

      if (api != null) {
        searchCategories.value = api.categories;
        searchProducts.value = api.products;
        searchNews.value = api.news;
      }
    }
  }

  clearSearch() {
    searchCategories.clear();
    searchProducts.clear();
    searchNews.clear();
    searchText.value = '';
    Helper.closeKeyboard();
  }

  Future<void> startListening() async {
    searchText.value = '';
    isSearch.value = true;

    if (isAvailable.value) {
      isListening.value = true;

      speech.listen(
          onResult: (result) {
            searchText.value = result.recognizedWords;

            if (result.finalResult) {
              if (searchText.value.isEmpty) {
                searchCategories.clear();
                searchProducts.clear();
                searchNews.clear();
                return;
              }

              HomeApi.search(searchText.value).then((api) {
                if (api != null) {
                  searchCategories.value = api.categories;
                  searchProducts.value = api.products;
                  searchNews.value = api.news;
                }
              });
            }
          }
      );
    }
  }

  void stopListening() {
    speech.stop();
    isListening.value = false;
    isSearch.value = false;
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