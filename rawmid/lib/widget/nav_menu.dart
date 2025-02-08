import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/navigation.dart';
import 'h.dart';

class NavMenuView extends StatelessWidget {
  const NavMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Container(
      color: Color(0xFF1E1E1E),
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(top: 8, bottom: 14, left: 10, right: 10),
      height: 40 + MediaQuery.of(context).viewPadding.bottom,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(5, (index) => IconButton(
              onPressed: () => navController.onItemTapped(index),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(maxWidth: 54),
              icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon/${index + 1}.png'),
                    h(4),
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                          navController.titles[index],
                          style: TextStyle(
                              color: Color(0xFFDDDADA),
                              fontSize: 10,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w400
                          )
                      )
                    )
                  ]
              )
          ))
      )
    );
  }
}