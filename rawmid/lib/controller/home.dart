import 'package:get/get.dart';
import 'package:rawmid/api/home.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/home/news.dart';
import 'package:rawmid/model/home/rank.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/club.dart';
import '../model/club/achievement.dart';
import '../model/home/achieviment.dart';
import '../model/home/banner.dart';
import '../model/home/product.dart';
import '../model/home/special.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BannerModel> banners = <BannerModel>[].obs;
  Rxn<AchievimentModel> achieviment = Rxn<AchievimentModel>();
  var ranks = <RankModel>[].obs;
  RxList<ProductModel> myProducts = <ProductModel>[].obs;
  RxList<ProductModel> viewedList = <ProductModel>[].obs;
  RxList<ProductModel> shopProducts = <ProductModel>[].obs;
  RxList<SpecialModel> specials = <SpecialModel>[].obs;
  RxList<NewsModel> news = <NewsModel>[].obs;
  RxList<NewsModel> recipes = <NewsModel>[].obs;
  final navController = Get.find<NavigationController>();
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  var viewed = (Helper.prefs.getStringList('viewed') ?? <String>[]).obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    isLoading.value = false;
    final banners = await HomeApi.getBanner({});
    this.banners.value = banners;

    final map = await ClubApi.getAchievements();
    var items = <AchievementModel>[];

    if (map['achievements'] != null) {
      for (var i in map['achievements']) {
        items.add(AchievementModel.fromJson(i));
      }
    }

    var items2 = <AchievementModel>[];

    if (map['not_achievements'] != null) {
      for (var i in map['not_achievements']) {
        items2.add(AchievementModel.fromJson(i));
      }
    }

    final user = navController.user.value;

    achieviment.value = AchievimentModel(
        name: user?.rangStr ?? (items.isNotEmpty ? items.first.title : 'Пионер'),
        rang: user?.rang ?? 0,
        max: 12000,
        achievements: items,
        notAchievements: items2
    );

    isLoading.value = true;

    HomeApi.getRanks().then((e) {
      ranks.value = e;
    });

    HomeApi.getSernum().then((e) {
      myProducts.value = e;
    });

    if (viewed.isNotEmpty) {
      HomeApi.getViewed(viewed).then((e) {
        viewedList.value = e;
      });
    }

    HomeApi.getFeatured().then((e) {
      shopProducts.value = e;
    });

    HomeApi.getRecords().then((e) {
      specials.value = e;
    });

    HomeApi.getNews().then((e) {
      news.value = e;
    });

    HomeApi.getRecipes().then((e) {
      recipes.value = e;
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
    Helper.trigger.value++;
    navController.wishlist.value = wishlist;
  }
}