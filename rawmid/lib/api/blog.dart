import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/home/news.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class BlogApi {
  static Future<Map<String, dynamic>> blog(bool recipe) async {
    try {
      final response = await http.get(Uri.parse('$getBlogUrl&recipe=${recipe ? 1 : 0}'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['blog']['news'] != null) {
        return json;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }

  static Future<NewsModel?> getNew(String id, bool recipe) async {
    try {
      final response = await http.post(Uri.parse(getNewUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'id': id, 'recipe': '${recipe ? 1 : 0}'});
      final json = jsonDecode(response.body);

      if (json['record'] != null) {
        return NewsModel.fromJson(json['record']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}