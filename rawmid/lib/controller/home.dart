import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/home.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/home/news.dart';
import 'package:rawmid/model/home/rank.dart';
import 'package:rawmid/utils/helper.dart';
import '../model/home/achieviment.dart';
import '../model/home/banner.dart';
import '../model/home/product.dart';
import '../model/home/special.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  final searchField = TextEditingController();
  RxList<BannerModel> banners = <BannerModel>[].obs;
  Rxn<AchievimentModel> achieviment = Rxn<AchievimentModel>();
  RxList<ProductModel> myProducts = <ProductModel>[].obs;
  RxList<ProductModel> shopProducts = <ProductModel>[].obs;
  RxList<SpecialModel> specials = <SpecialModel>[].obs;
  RxList<NewsModel> news = <NewsModel>[].obs;
  RxList<NewsModel> recipes = <NewsModel>[].obs;
  final navController = Get.find<NavigationController>();
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    final banners = await HomeApi.getBanner();
    this.banners.addAll(banners);

    final items = await HomeApi.getRanks();
    List<RankModel> ranks = [];

    if (items.isNotEmpty) {
      for (var rank in items) {
        ranks.add(rank);
      }
    }

    final user = navController.user.value;

    achieviment.value = AchievimentModel(
        name: user?.rangStr ?? 'Новичок',
        rang: user?.rang ?? 0,
        max: ranks.isNotEmpty ? int.tryParse('${ranks.last.rewards}') ?? 2000 : 2000,
        ranks: ranks
    );

    isLoading.value = true;

    HomeApi.getSernum().then((e) {
      myProducts.addAll(e);
    });

    HomeApi.getFeatured().then((e) {
      shopProducts.addAll(e);
    });

    HomeApi.getRecords().then((e) {
      specials.addAll(e);
    });

    HomeApi.getNews().then((e) {
      news.addAll(e);
    });

    HomeApi.getRecipes().then((e) {
      recipes.addAll(e);
    });
  }

  Future addWishlist(String id) async {
    if (wishlist.contains(id)) {
      wishlist.remove(id);
    } else {
      wishlist.add(id);
    }

    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
  }
}