import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/home/news.dart';
import 'package:rawmid/utils/constant.dart';
import '../../controller/home.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import 'recipies.dart';
import 'shop.dart';
import '../../widget/h.dart';
import 'achieviments.dart';
import 'my_product.dart';
import 'slideshow.dart';
import 'special.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Obx(() => SafeArea(
            child: controller.isLoading.value ? SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                        children: [
                          h(20),
                          SearchBarView(),
                          if (controller.banners.isEmpty) h(20),
                          if (controller.banners.isNotEmpty) SlideshowView(banners: controller.banners, button: true),
                          if (controller.achieviment.value != null) AchievementsSection(item: controller.achieviment.value!, callback: () {
                            if (controller.navController.user.value == null) {
                              Get.toNamed('register');
                            }
                          }),
                          if (controller.myProducts.isNotEmpty) MyProductsSection(products: controller.myProducts),
                          if (controller.shopProducts.isNotEmpty) StoreSection(products: controller.shopProducts, showMore: () => controller.navController.onItemTapped(1), addWishlist: controller.addWishlist, buy: (id) => controller.navController.addCart(id)),
                          if (controller.specials.isNotEmpty) PromotionsSection(specials: controller.specials),
                          if (controller.news.isNotEmpty) NewsSection(news: controller.news, padding: true, callback: () => Get.toNamed('/blog')),
                          if (controller.recipes.isNotEmpty) RecipesSection(recipes: controller.recipes, callback: () {
                            if (controller.navController.user.value == null) {
                              Get.toNamed('register');
                            }
                          }),
                          Container(height: 40, color: Colors.white)
                        ]
                    ),
                    SearchWidget()
                  ]
                )
            ) : Center(
              child: CircularProgressIndicator(color: primaryColor)
            )
        ))
    );
  }
}