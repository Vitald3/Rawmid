import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import '../utils/constant.dart';
import '../utils/utils.dart';

class SearchBarView extends GetView<NavigationController> {
  const SearchBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
            autocorrect: false,
            cursorHeight: 15,
            style: const TextStyle(
              color: firstColor,
              fontSize: 11,
              fontWeight: FontWeight.w500
            ),
            onChanged: controller.search,
            onSaved: (_) => controller.clearSearch(),
            onFieldSubmitted: (_) => controller.clearSearch(),
            onEditingComplete: controller.clearSearch,
            decoration: decorationInput(
              hint: 'Поиск товаров, рецептов, статей',
              prefixIcon: Image.asset('assets/image/search.png'),
              suffixIcon: controller.isAvailable.value ? InkWell(
                onTap: controller.isListening.value ? controller.stopListening : controller.startListening,
                child: Image.asset(controller.isListening.value ? 'assets/icon/microphone_active.png' : 'assets/image/microphone.png')
              ) : null
            ),
            textInputAction: TextInputAction.done
        )
    ));
  }
}