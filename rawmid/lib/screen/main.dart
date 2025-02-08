import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/widget/menu.dart';
import '../controller/navigation.dart';
import '../widget/nav_menu.dart';
import '../widget/w.dart';

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

    return Scaffold(
        appBar: AppBar(
            titleSpacing: 20,
            leading: SizedBox.shrink(),
            leadingWidth: 0,
            title: Row(
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
                  if (controller.city.value.isNotEmpty) InkWell(
                      onTap: () {},
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
        ),
        drawer: MenuView(controller: controller),
        body: IndexedStack(
            index: act,
            children: List.generate(controller.widgetOptions.length, (index) => controller.widgetOptions.elementAt(index))
        ),
        backgroundColor: Color(0xFFF0F0F0),
        bottomNavigationBar: NavMenuView()
    );
  }
}