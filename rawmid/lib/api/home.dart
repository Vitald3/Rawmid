import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/model/home/news.dart';
import '../model/home/product.dart';
import '../model/home/rank.dart';
import '../model/home/special.dart';
import '../utils/constant.dart';

class HomeApi {
  static Future<String> getCityByIP() async {
    final response = await http.get(Uri.parse('http://ip-api.com/json/'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['city'];
    }

    return '';
  }

  static Future<List<BannerModel>> getBanner() async {
    List<BannerModel> items = [];

    try {
      final response = await http.get(Uri.parse(getBannerUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['banners'] != null) {
        for (var i in json['banners']) {
          items.add(BannerModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<int> getUrlProduct(String link) async {
    int id = 0;

    try {
      final response = await http.post(Uri.parse(getUrlProductUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {'link': link});
      final json = jsonDecode(response.body);

      return json['id'] ?? 0;
    } catch (e) {
      debugPrint(e.toString());
    }

    return id;
  }

  static Future<List<RankModel>> getRanks() async {
    List<RankModel> items = [];

    try {
      final response = await http.get(Uri.parse(getRanksUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['ranks'] != null) {
        for (var i in json['ranks']) {
          items.add(RankModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<ProductModel>> getFeatured() async {
    List<ProductModel> items = [];

    try {
      final response = await http.get(Uri.parse(getFeaturedUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(ProductModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<ProductModel>> getSernum() async {
    List<ProductModel> items = [];

    try {
      final response = await http.get(Uri.parse(getSernumUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(ProductModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<SpecialModel>> getRecords() async {
    List<SpecialModel> items = [];

    try {
      final response = await http.get(Uri.parse(getRecordsUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['records'] != null) {
        for (var i in json['records']) {
          items.add(SpecialModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<NewsModel>> getNews() async {
    List<NewsModel> items = [];

    try {
      final response = await http.get(Uri.parse(getNewsUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['news'] != null) {
        for (var i in json['news']) {
          items.add(NewsModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<NewsModel>> getRecipes() async {
    List<NewsModel> items = [];

    try {
      final response = await http.get(Uri.parse(getRecipesUrl), headers: {
        'Content-Type': 'application/json'
      });
      final json = jsonDecode(response.body);

      if (json['news'] != null) {
        for (var i in json['news']) {
          items.add(NewsModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}