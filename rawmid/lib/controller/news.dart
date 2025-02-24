import 'package:get/get.dart';
import 'package:rawmid/api/blog.dart';
import 'package:rawmid/model/home/news.dart';

class NewsController extends GetxController {
  String id;
  NewsController(this.id) {
    initialize();
  }

  RxBool isLoading = false.obs;
  Rxn<NewsModel> news = Rxn();

  Future initialize() async {
    news.value = await BlogApi.getNew(id);
    isLoading.value = true;
  }

  setId(String val) {
    isLoading.value = false;
    id = val;
  }
}