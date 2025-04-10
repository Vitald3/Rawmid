import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/home.dart';
import 'package:rawmid/widget/menu.dart';
import '../controller/cart.dart';
import '../controller/navigation.dart';
import '../widget/nav_menu.dart';
import '../widget/w.dart';
import 'home/city.dart';

class MainView extends StatelessWidget {
  const MainView({super.key, this.index});

  final int? index;

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationController());
    final navController = Get.find<NavigationController>();

    return Obx(() => buildNavigator(navController, context));
  }

  buildNavigator(NavigationController controller, BuildContext context) {
    int act = controller.activeTab.value;

    if (!controller.reset.value && index != null) {
      act = index!;
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.resetV());
    }

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (type, val) async {
          if (!type && controller.activeTab.value != 0) {
            controller.onItemTapped(0);
          }

          return;
        },
        child: Scaffold(
            appBar: AppBar(
                titleSpacing: 20,
                leading: SizedBox.shrink(),
                leadingWidth: 0,
                title: ClipRect(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                Builder(
                                    builder: (context) => InkWell(
                                        onTap: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        child: Image.asset('assets/icon/burger.png')
                                    )
                                ),
                                w(26),
                                Image.asset('assets/image/logo.png', width: 70)
                              ]
                          ),
                          if (controller.city.value.isNotEmpty) w(10),
                          if (controller.city.value.isNotEmpty) Expanded(
                              child: InkWell(
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
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.location_on_rounded, color: Color(0xFF14BFFF)),
                                            w(6),
                                            Flexible(
                                                child: Text(
                                                    controller.city.value,
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xFF14BFFF),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                              )
                          )
                        ]
                    )
                )
            ),
            drawer: MenuView(controller: controller),
            body: IndexedStack(
                index: act,
                children: List.generate(controller.widgetOptions.length, (index) => controller.widgetOptions.elementAt(index))
            ),
            backgroundColor: Color(0xFFF0F0F0),
            bottomNavigationBar: NavMenuView()
        )
    );
  }
}