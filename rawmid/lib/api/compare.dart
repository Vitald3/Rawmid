import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/compare.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class CompareApi {
  static Future<List<CompareProductModel>> getCompares(String ids) async {
    List<CompareProductModel> items = [];

    try {
      final response = await http.post(Uri.parse(comparesUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'ids': ids});
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(CompareProductModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}