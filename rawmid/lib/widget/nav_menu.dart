import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/constant.dart';
import '../controller/navigation.dart';
import 'h.dart';

class NavMenuView extends StatelessWidget {
  const NavMenuView({super.key, this.nav});

  final bool? nav;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Container(
      color: Color(0xFF1E1E1E),
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(top: 8, bottom: 14, left: 10, right: 10),
      height: (Platform.isAndroid ? 60 : 40) + MediaQuery.of(context).viewPadding.bottom,
      child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(5, (index) => IconButton(
              onPressed: () {
                navController.onItemTapped(index);

                if (nav ?? false) {
                  Get.back();

                  if (Navigator.canPop(context)) {
                    Get.back();
                  }
                }
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(maxWidth: 54),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/${index + 1}${navController.activeTab.value == index ? '_active' : ''}.png', width: 16, height: 16),
                        h(4),
                        FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                                navController.titles[index],
                                style: TextStyle(
                                    color: navController.activeTab.value == index ? Colors.white : Color(0xFFC3BEBE),
                                    fontSize: 10,
                                    letterSpacing: 0.1,
                                    fontWeight: FontWeight.w900
                                )
                            )
                        )
                      ]
                  ),
                  if (index == 4 && navController.cartProducts.isNotEmpty) Positioned(
                      right: 2,
                      top: -4,
                      child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle
                          ),
                          constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16
                          ),
                          child: Text(
                              '${navController.cartProducts.map((e) => e.quantity).reduce((a, b) => (a ?? 0) + (b ?? 0))}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center
                          )
                      )
                  ),
                  if (index == 3 && navController.wishlist.isNotEmpty) Positioned(
                      right: 10,
                      top: -4,
                      child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle
                          ),
                          constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16
                          ),
                          child: Text(
                              '${navController.wishlist.length}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center
                          )
                      )
                  )
                ]
              )
          ))
      ))
    );
  }
}