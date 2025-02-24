import 'dart:async';

import 'package:get/get.dart';
import 'package:rawmid/controller/home.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/catalog.dart';

class CatalogController extends GetxController {
  RxBool isLoading = false.obs;
  final navController = Get.find<NavigationController>();
  HomeController? homeController;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ProductModel> specials = <ProductModel>[].obs;
  RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    Timer.periodic(const Duration(seconds: 1), (t) {
      homeController ??= Get.find<HomeController>();
    });

    CatalogApi.getCategories().then((e) {
      categories.value = e;
    });

    CatalogApi.getSpecials().then((e) {
      specials.value = e;
    });

    CatalogApi.getPredloz().then((e) {
      banners.value = e;
    });

    isLoading.value = true;
  }

  Future addWishlist(String id) async {
    if (wishlist.contains(id)) {
      wishlist.remove(id);
    } else {
      wishlist.add(id);
    }

    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
    Helper.trigger.value++;
    navController.wishlist.value = wishlist;
  }
}