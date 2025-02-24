import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/blog.dart';
import 'package:rawmid/model/home/news.dart';

class BlogController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<NewsModel> news = <NewsModel>[].obs;
  RxList<NewsModel> featured = <NewsModel>[].obs;
  RxInt activeIndex = 0.obs;
  final pageController = PageController(viewportFraction: 0.85);

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    final api = await BlogApi.blog();

    if (api.isNotEmpty) {
      for (var i in api['blog']['news']) {
        news.add(NewsModel.fromJson(i));
      }

      for (var i in api['blog']['featured']) {
        featured.add(NewsModel.fromJson(i));
      }
    }

    isLoading.value = true;
  }
}