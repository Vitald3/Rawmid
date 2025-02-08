import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/home/news.dart';
import 'package:rawmid/utils/constant.dart';
import '../../controller/home.dart';
import '../../utils/utils.dart';
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
                child: Column(
                    children: [
                      h(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                            controller: controller.searchField,
                            autocorrect: false,
                            style: TextStyle(
                                color: firstColor,
                                fontSize: 11,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w500
                            ),
                            minLines: 1,
                            maxLines: 1,
                            decoration: decorationInput(hint: 'Поиск товаров, рецептов, статей', prefixIcon: Image.asset('assets/image/search.png'), suffixIcon: Image.asset('assets/image/microphone.png')),
                            textInputAction: TextInputAction.done
                        )
                      ),
                      if (controller.banners.isNotEmpty) SlideshowView(banners: controller.banners),
                      if (controller.achieviment.value != null) AchievementsSection(item: controller.achieviment.value!),
                      if (controller.myProducts.isNotEmpty) MyProductsSection(products: controller.myProducts),
                      if (controller.shopProducts.isNotEmpty) StoreSection(controller: controller),
                      if (controller.specials.isNotEmpty) PromotionsSection(specials: controller.specials),
                      if (controller.news.isNotEmpty) NewsSection(news: controller.news),
                      if (controller.recipes.isNotEmpty) RecipesSection(recipes: controller.recipes),
                      Container(height: 40, color: Colors.white)
                    ]
                )
            ) : Center(
              child: CircularProgressIndicator(color: primaryColor)
            )
        ))
    );
  }
}