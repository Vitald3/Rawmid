import 'package:rawmid/model/home/product.dart';
import 'news.dart';

class SearchModel {
  late List<ProductModel> products;
  late List<NewsModel> news;

  SearchModel({
    required this.products,
    required this.news
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      List<ProductModel> items = [];

      for (var i in json['products']) {
        items.add(ProductModel.fromJson(i));
      }

      products = items;
    }

    if (json['news'] != null) {
      List<NewsModel> items = [];

      for (var i in json['news']) {
        items.add(NewsModel.fromJson(i));
      }

      news = items;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['products'] = products;
    data['news'] = news;
    return data;
  }
}
