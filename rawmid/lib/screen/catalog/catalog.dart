import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/catalog/banner.dart';
import 'package:rawmid/screen/catalog/slideshow.dart';
import 'package:rawmid/utils/constant.dart';
import '../../controller/catalog.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../home/shop.dart';
import '../../widget/h.dart';
import 'category.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CatalogController>(
        init: CatalogController(),
        builder: (controller) => Obx(() => SafeArea(
            child: controller.isLoading.value ? SingleChildScrollView(
                child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                          children: [
                            h(20),
                            SearchBarView(),
                            h(20),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  if (controller.homeController != null && controller.homeController!.banners.isNotEmpty) SlideshowCatalogView(banners: controller.homeController!.banners),
                                  if (controller.categories.isNotEmpty) CategorySection(categories: controller.categories),
                                  if (controller.specials.isNotEmpty) StoreSection(title: 'Товары со скидкой', products: controller.specials, addWishlist: controller.addWishlist, buy: (id) async {
                                    await controller.navController.addCart(id);
                                    controller.update();
                                  }),
                                  if (controller.banners.isNotEmpty) BannerView(banners: controller.banners, title: 'Особые предложения'),
                                  if (controller.homeController != null && controller.homeController!.shopProducts.isNotEmpty) StoreSection(title: 'Рекомендуемые товары', products: controller.homeController!.shopProducts, addWishlist: controller.addWishlist, buy: (id) async {
                                    await controller.navController.addCart(id);
                                    controller.update();
                                  }),
                                  h(40)
                                ]
                              )
                            )
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