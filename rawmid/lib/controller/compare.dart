import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/compare.dart';
import '../model/compare.dart';

class CompareController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CompareProductModel> compares = <CompareProductModel>[].obs;
  RxList<String> titles = <String>[].obs;
  RxList<GlobalKey> keys = <GlobalKey>[].obs;
  RxList<GlobalKey> keys2 = <GlobalKey>[].obs;
  RxMap<int, double> height = <int, double>{}.obs;
  RxInt rowIndex = (-1).obs;
  final navController = Get.find<NavigationController>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future setHeight(int index, double val) async {
    if (height.containsKey(index) && height[index]! < val) {
      height[index] = val;
    } else {
      height.putIfAbsent(index, () => val);
    }
  }

  Future initialize() async {
    final ids = Helper.compares.value.join(',');

    if (ids.isNotEmpty) {
      compares.value = await CompareApi.getCompares(ids);

      titles.addAll([
        'Товар',
        '',
        'Категория',
        'Цена',
        'Производитель',
        'Модель',
        'Наличие',
        'Рейтинг',
        'Цвет'
      ]);

      for (var compare in compares) {
        for (var attribute in compare.attributes) {
          titles.add(attribute.name);
        }
      }

      titles.value = titles.toSet().toList();

      for (var _ in titles) {
        keys.add(GlobalKey());
        keys2.add(GlobalKey());
      }
    }

    isLoading.value = true;
  }
}