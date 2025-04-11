import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../controller/compare.dart';
import '../widget/h.dart';

class CompareView extends StatelessWidget {
  const CompareView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompareController>(
        init: CompareController(),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: Get.back,
                              icon: Image.asset('assets/icon/left.png')
                          ),
                          Image.asset('assets/image/logo.png', width: 70)
                        ]
                    )
                )
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Obx(() => Stack(
                    children: [
                      controller.isLoading.value ? SingleChildScrollView(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                              children: [
                                h(16),
                                ModuleTitle(title: 'Сравнение товаров', type: true),
                                h(10),
                                controller.compares.isNotEmpty ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          color: Color(0xFFF6F8F9),
                                          width: 130,
                                          child: Column(
                                              children: List.generate(controller.titles.length, (index) {
                                                if (controller.height[index] == null) {
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    final RenderBox renderBox = controller.keys[index].currentContext?.findRenderObject() as RenderBox;
                                                    controller.setHeight(index, renderBox.size.height);
                                                  });
                                                }

                                                return Container(
                                                    key: controller.keys[index],
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: controller.height[index] != null ? 0 : 8),
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFFF6F8F9),
                                                        border: Border(
                                                            bottom: BorderSide(width: 1, color: Color(0xFFDDE8EA))
                                                        )
                                                    ),
                                                    height: controller.height[index] != null ? controller.height[index]! + 1 : 44,
                                                    child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                  controller.titles[index],
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      color: Color(0xFF8A95A8),
                                                                      fontSize: 12,
                                                                      height: 1
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    )
                                                );
                                              }).toList()
                                          )
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.only(right: 20),
                                              child: Column(
                                                  children: List.generate(controller.titles.length + 1, (index) {
                                                    if (index == controller.titles.length) {
                                                      return Row(
                                                          children: List.generate(controller.compares.length, (index3) {
                                                            return Container(
                                                                width: 130,
                                                                padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                                                                child: PrimaryButton(text: controller.navController.isCart(controller.compares[index3].id) ? 'В корзине' : 'Купить', height: 40, onPressed: () {
                                                                  controller.navController.addCart(controller.compares[index3].id);
                                                                })
                                                            );
                                                          })
                                                      );
                                                    }

                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                      final RenderBox renderBox = controller.keys2[index].currentContext?.findRenderObject() as RenderBox;

                                                      if ((controller.height[index] ?? 44) < renderBox.size.height) {
                                                        controller.height[index] = renderBox.size.height;
                                                      }
                                                    });

                                                    return Container(
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(width: 1, color: Color(0xFFDDE8EA))
                                                            )
                                                        ),
                                                        height: controller.height[index] != null ? controller.height[index]! + 1 : null,
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                            key: controller.keys2[index],
                                                            spacing: 4,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: List.generate(controller.compares.length, (index2) {
                                                              final compare = controller.compares[index2];

                                                              if (index == 1) {
                                                                return GestureDetector(
                                                                    onTap: () => Get.to(() => ProductView(id: compare.id)),
                                                                    child: Container(
                                                                        width: 130,
                                                                        height: 120,
                                                                        alignment: Alignment.center,
                                                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: controller.height[index] != null ? 0 : 8),
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: compare.image,
                                                                            errorWidget: (c, e, i) {
                                                                              return Image.asset('assets/image/no_image.png', fit: BoxFit.contain);
                                                                            },
                                                                            fit: BoxFit.contain,
                                                                            height: 120,
                                                                            width: double.infinity
                                                                        )
                                                                    )
                                                                );
                                                              }

                                                              if (index == 3) {
                                                                return Container(
                                                                    width: 130,
                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: controller.height[index] != null ? 0 : 8),
                                                                    child: compare.special.isEmpty ? Text(compare.price, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 0.8)) : Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          if (compare.special.isNotEmpty) Text(compare.special, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 0.8)),
                                                                          if (compare.price.isNotEmpty) Text(compare.price, style: TextStyle(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough))
                                                                        ]
                                                                    )
                                                                );
                                                              }

                                                              if (index == 7) {
                                                                return Container(
                                                                    width: 130,
                                                                    alignment: Alignment.center,
                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: controller.height[index] != null ? 0 : 8),
                                                                    child: compare.rating > 0 ? Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [1,2,3,4,5].map((e) => Icon(e <= compare.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                                                    ) : SizedBox.shrink()
                                                                );
                                                              }

                                                              String? title;

                                                              if (index == 0) {
                                                                title = compare.name;
                                                              } else if (index == 2) {
                                                                title = compare.category;
                                                              } else if (index == 4) {
                                                                title = compare.manufacturer;
                                                              } else if (index == 5) {
                                                                title = compare.model;
                                                              } else if (index == 6) {
                                                                title = compare.availability;
                                                              } else if (index == 8) {
                                                                title = compare.color;
                                                              }

                                                              if (title != null) {
                                                                return GestureDetector(
                                                                    onTap: () {
                                                                      if (index == 0) {
                                                                        Get.to(() => ProductView(id: compare.id));
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: controller.height[index] != null ? 0 : 8),
                                                                        width: 130,
                                                                        alignment: Alignment.center,
                                                                        child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Text(
                                                                                      title,
                                                                                      maxLines: 3,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                          color: index == 0 ? primaryColor : Color(0xFF1E1E1E),
                                                                                          fontSize: 12,
                                                                                          height: 1.40
                                                                                      )
                                                                                  )
                                                                              )
                                                                            ]
                                                                        )
                                                                    )
                                                                );
                                                              }

                                                              return Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: controller.height[index] != null ? 0 : 8),
                                                                  width: 130,
                                                                  alignment: Alignment.center,
                                                                  child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child: Text(
                                                                                compare.attributes.firstWhereOrNull((e) => e.name == controller.titles[index])?.text ?? '',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Color(0xFF1E1E1E),
                                                                                    fontSize: 12,
                                                                                    height: 1.40
                                                                                )
                                                                            )
                                                                        )
                                                                      ]
                                                                  )
                                                              );
                                                            })
                                                        )
                                                    );
                                                  })
                                              )
                                          )
                                      )
                                    ]
                                ) : Center(
                                    child: Text('Вы еще не добавляли в сравнение', style: TextStyle(fontSize: 16))
                                ),
                                h(20 + MediaQuery.of(context).padding.bottom)
                              ]
                          )
                      ) : Center(
                          child: CircularProgressIndicator(color: primaryColor)
                      )
                    ]
                ))
            )
        )
    );
  }
}