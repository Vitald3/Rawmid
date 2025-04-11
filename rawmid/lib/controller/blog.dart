import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/blog.dart';
import 'package:rawmid/model/home/news.dart';

import '../model/home/category_news.dart';

class BlogController extends GetxController {
  var id = ''.obs;
  var isLoading = false.obs;
  var isRecipe = false.obs;
  var news = <NewsModel>[].obs;
  var featured = <NewsModel>[].obs;
  var activeIndex = 0.obs;
  final pageController = PageController(viewportFraction: 0.85);
  var categories = <CategoryNewsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future setCategory(String id) async {
    this.id.value = id;
    isLoading.value = false;

    final api = await BlogApi.blog(true, id: id);
    news.clear();

    if (api.isNotEmpty) {
      for (var i in api['blog']['news'] ?? []) {
        news.add(NewsModel.fromJson(i));
      }
    }

    isLoading.value = true;
  }

  Future initialize() async {
    isRecipe.value = Get.arguments != null;

    if (isRecipe.value) {
      final categories = await BlogApi.getCategoriesRecipe();
      this.categories.value = categories;

      if (categories.isNotEmpty) {
        isLoading.value = true;
        return;
      }
    }

    final api = await BlogApi.blog(Get.arguments != null, mySurvey: Get.parameters['my_survey'] == '1', myRecipes: Get.parameters['my_recipes'] == '1');

    if (api.isNotEmpty) {
      for (var i in api['blog']['news'] ?? []) {
        news.add(NewsModel.fromJson(i));
      }

      if (!isRecipe.value) {
        for (var i in api['blog']['featured'] ?? []) {
          featured.add(NewsModel.fromJson(i));
        }
      }
    }

    isLoading.value = true;
  }
}