import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/profile.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class LoginApi {
  static Future<ProfileModel?> register(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(registerUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: body);

      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        await Helper.prefs.setString('PHPSESSID', json['session_id']);
        return ProfileModel.fromJson(json['user']);
      } else {
        Helper.snackBar(error: true, text: json['message'] ?? 'Ошибка данных');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<ProfileModel?> loginCode(Map<String, String> body) async {
    try {
      final response = await http.post(Uri.parse(loginCodeUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: body
      );

      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        await Helper.prefs.setString('PHPSESSID', json['session_id']);

        return ProfileModel.fromJson(json['user']);
      } else {
        Helper.snackBar(error: true, text: json['message'] ?? 'Ошибка данных');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<ProfileModel?> login(Map<String, String> body) async {
    try {
      final response = await http.post(Uri.parse(loginUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: body
      );

      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        await Helper.prefs.setString('PHPSESSID', json['session_id']);

        return ProfileModel.fromJson(json['user']);
      } else {
        Helper.snackBar(error: true, text: json['message'] ?? 'Ошибка данных');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<bool> sendCode(String email) async {
    try {
      final response = await http.post(Uri.parse(sendCodeUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {'email': email});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }
}