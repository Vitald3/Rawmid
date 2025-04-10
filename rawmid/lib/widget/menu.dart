import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/w.dart';
import '../controller/cart.dart';
import '../controller/home.dart';
import '../screen/home/city.dart';
import 'h.dart';
import 'package:get/get.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key, required this.controller});

  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      children: [
                        h(4),
                        _buildSection('Покупки', [
                          if (controller.user.value != null) _buildDrawerItem('order', 'Мои заказы', () => Get.toNamed('/orders')),
                          if (controller.user.value != null) _buildDrawerItem('my_product', 'Мои товары', () {}),
                          if (controller.user.value != null) _buildDrawerItem('rev', 'Мои отзывы', () => Get.toNamed('/reviews')),
                          _buildDrawerItem('shop', 'Магазин', () {
                            controller.onItemTapped(1);
                            Scaffold.of(context).closeDrawer();
                          }),
                          _buildDrawerItem('compare', 'Сравнение товаров', () {
                            Get.toNamed('/compare');
                            Scaffold.of(context).closeDrawer();
                          }),
                          _buildDrawerItem('special', 'Акции', () {}, divider: false),
                        ]),
                        _buildSection('Информация', [
                          _buildDrawerItem('news', 'Статьи', () => Get.toNamed('/blog')),
                          _buildDrawerItem('receipe', 'Рецепты', () {
                            if (controller.user.value == null) {
                              Get.toNamed('register');
                            } else {
                              Get.toNamed('/blog', arguments: true);
                            }
                          }, divider: false),
                        ]),
                        _buildSection('Профиль', [
                          if (controller.user.value != null) _buildDrawerItem('setting', 'Настройки', () => Get.toNamed('user')),
                          _buildDrawerItem('support', 'Поддержка', () => Get.toNamed('/support'), divider: false),
                        ])
                      ]
                  )
              )
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _buildDrawerItem(controller.user.value != null ? 'logout' : 'login', controller.user.value != null ? 'Выйти' : 'Войти', () {
                  if (controller.user.value != null) {
                    controller.logout();
                  } else {
                    Get.toNamed('register');
                  }
                }, color: controller.user.value != null ? dangerColor : primaryColor, divider: false)
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Text('© Rawmid ${DateTime.now().year}',
                    style: TextStyle(color: Colors.grey)
                )
            )
          ]
      ))
    );
  }

  Widget _buildHeader() {
    return DrawerHeader(
      child: Column(
          children: [
            if (controller.user.value != null) Row(
                children: [
                  CircleAvatar(
                    backgroundImage: (controller.user.value?.image ?? '').isNotEmpty ? CachedNetworkImageProvider(controller.user.value!.image) : AssetImage('assets/image/empty.png'),
                  ),
                  w(12),
                  Expanded(
                    child: Text(
                        controller.user.value!.fio,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis
                    )
                  )
                ]
            ),
            h(10),
            Row(
                children: [
                  Chip(
                      label: Row(
                          children: [
                            Text('${controller.user.value?.rang ?? '0'}', style: TextStyle(color: Colors.white)),
                            w(4),
                            Image.asset('assets/icon/rang.png')
                          ]
                      ),
                      backgroundColor: Colors.blue
                  ),
                  w(8),
                  Chip(
                    label: Text('Ранг: ${controller.user.value?.rangStr ?? 'Новичок'}', style: TextStyle(color: primaryColor)),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: primaryColor),
                  )
                ]
            ),
            if (controller.city.value.isNotEmpty) h(14),
            if (controller.city.value.isNotEmpty) InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: Get.context!,
                      isScrollControlled: true,
                      useSafeArea: true,
                      useRootNavigator: true,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                      ),
                      builder: (context) {
                        return CitySearch();
                      }
                  ).then((_) {
                    controller.filteredCities.value = controller.cities;
                    controller.filteredLocation.clear();

                    if (Get.isRegistered<HomeController>()) {
                      final home = Get.find<HomeController>();
                      home.initialize();
                    }

                    if (Get.isRegistered<CartController>()) {
                      final cart = Get.find<CartController>();
                      cart.initialize();
                    }
                  });
                },
                child: Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: Color(0xFF14BFFF)),
                      w(12),
                      Text(
                          controller.city.value,
                          style: TextStyle(
                              color: Color(0xFF14BFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          )
                      )
                    ]
                )
            )
          ]
      )
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)),
          Column(children: items)
        ]
      )
    );
  }

  Widget _buildDrawerItem(String icon, String title, Function() callback, {Color color = Colors.black, bool divider = true}) {
    return Column(
      children: [
        ListTile(
            leading: Image.asset('assets/icon/$icon.png', width: 17, height: 17),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Text(title, style: TextStyle(color: color, fontSize: 20)),
            onTap: callback
        ),
        if (divider) Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1)
      ]
    );
  }
}