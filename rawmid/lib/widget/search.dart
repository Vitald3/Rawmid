import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/controller/news.dart';
import 'package:rawmid/widget/w.dart';
import '../controller/product.dart';
import '../screen/news/news.dart';
import '../screen/product/product.dart';
import '../utils/constant.dart';
import 'h.dart';

class SearchWidget extends GetView<NavigationController> {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top + 69,
        child: Obx(() => controller.searchProducts.isNotEmpty || controller.searchNews.isNotEmpty || controller.searchText.isNotEmpty ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Color(0xFFDDE8EA), blurRadius: 4)]
            ),
            constraints: controller.searchProducts.isEmpty && controller.searchNews.isEmpty ? null : BoxConstraints(maxHeight: 240, minHeight: 100),
            child: Column(
                children: [
                  controller.searchProducts.isNotEmpty || controller.searchNews.isNotEmpty ? Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (controller.searchProducts.isNotEmpty) Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: controller.searchProducts.map((suggestion) {
                                      return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(12)
                                                    ),
                                                    clipBehavior: Clip.antiAlias,
                                                    width: 50,
                                                    height: 50,
                                                    child: CachedNetworkImage(
                                                        imageUrl: suggestion.image,
                                                        errorWidget: (c, e, i) {
                                                          return Image.asset('assets/image/no_image.png');
                                                        },
                                                        height: 50,
                                                        width: double.infinity,
                                                        fit: BoxFit.fill
                                                    )
                                                ),
                                                w(10),
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              suggestion.title,
                                                              maxLines: 3,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontSize: 13, height: 1)
                                                          ),
                                                          h(6),
                                                          SizedBox(
                                                              width: double.infinity,
                                                              child: (suggestion.special ?? '').isEmpty ? Text(suggestion.price ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)) : Wrap(
                                                                  alignment: WrapAlignment.start,
                                                                  runAlignment: WrapAlignment.spaceBetween,
                                                                  spacing: 10,
                                                                  children: [
                                                                    if ((suggestion.special ?? '').isNotEmpty) Text(suggestion.special!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                                    if ((suggestion.price ?? '').isNotEmpty) Text(
                                                                        suggestion.price!,
                                                                        style: TextStyle(
                                                                            fontSize: 12,
                                                                            color: primaryColor,
                                                                            decoration: TextDecoration.lineThrough)
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                              ]
                                          ),
                                          onTap: () {
                                            if (Get.currentRoute == '/ProductView') {
                                              final id = Get.find<ProductController>().id;
                                              Get.find<ProductController>().setId(suggestion.id);
                                              Get.find<ProductController>().initialize();
                                              Get.to(() => ProductView(id: suggestion.id), preventDuplicates: false)?.then((_) {
                                                Get.find<ProductController>().setId(id);
                                                Get.find<ProductController>().initialize();
                                              });
                                            } else {
                                              Get.to(() => ProductView(id: suggestion.id));
                                            }

                                            controller.clearSearch();
                                          }
                                      );
                                    }).toList()
                                ),
                                if (controller.searchNews.isNotEmpty) Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: controller.searchNews.map((suggestion) {
                                      return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(12)
                                                    ),
                                                    clipBehavior: Clip.antiAlias,
                                                    width: 50,
                                                    height: 50,
                                                    child: CachedNetworkImage(
                                                        imageUrl: suggestion.image,
                                                        errorWidget: (c, e, i) {
                                                          return Image.asset('assets/image/no_image.png');
                                                        },
                                                        height: 50,
                                                        width: double.infinity,
                                                        fit: BoxFit.fill
                                                    )
                                                ),
                                                w(10),
                                                Expanded(
                                                    child: Text(
                                                        suggestion.title,
                                                        maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 13, height: 1)
                                                    )
                                                )
                                              ]
                                          ),
                                          onTap: () {
                                            if (Get.currentRoute == '/NewsView') {
                                              final id = Get.find<NewsController>().id;
                                              Get.find<NewsController>().setId(suggestion.id);
                                              Get.find<NewsController>().initialize();
                                              Get.to(() => NewsView(id: suggestion.id), preventDuplicates: false)?.then((_) {
                                                Get.find<NewsController>().setId(id);
                                                Get.find<NewsController>().initialize();
                                              });
                                            } else {
                                              Get.to(() => NewsView(id: suggestion.id));
                                            }

                                            controller.clearSearch();
                                          }
                                      );
                                    }).toList()
                                )
                              ]
                          )
                      )
                  ) : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          'По данному запросу ничего не найдено'
                      )
                  )
                ]
            )
        )
            : SizedBox()
        )
    );
  }
}