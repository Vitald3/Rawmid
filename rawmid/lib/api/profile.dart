import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/country.dart';
import 'package:rawmid/model/profile.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class ProfileApi {
  static Future<ProfileModel?> user() async {
    try {
      final response = await http.get(Uri.parse(userUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<List<CountryModel>> countries() async {
    List<CountryModel> items = [];

    try {
      final response = await http.get(Uri.parse(countriesUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['countries'] != null) {
        for (var i in json['countries']) {
          items.add(CountryModel.fromJson(i));
        }

        return items;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future logout() async {
    try {
      await http.get(Uri.parse(userDeleteUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> delete() async {
    try {
      final response = await http.post(Uri.parse(userDeleteUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> changePass(String password) async {
    try {
      final response = await http.post(Uri.parse(changePassUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'password': password});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<ProfileModel?> saveAddress(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(saveAddressUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return null;
      }

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<ProfileModel?> setAddress(int id) async {
    try {
      final response = await http.post(Uri.parse(setAddressUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'address_id': '$id'});

      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return null;
      }

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<bool> setNewsletter(bool val) async {
    try {
      final response = await http.post(Uri.parse(setNewsletterUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'newsletter': '${val ? 1 : 0}'});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> setPush(bool val) async {
    try {
      final response = await http.post(Uri.parse(setPushUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'push': '${val ? 1 : 0}'});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> save(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(saveUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return false;
      }

      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

   static Future<bool> uploadImage(File image) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadAvatarUrl));

      request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          image.path
      ));

      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final response = await request.send();
      final json = jsonDecode(await response.stream.bytesToString());

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return false;
      }

      return json['status'] ?? false;
    } catch(e) {
      debugPrint(e.toString());
    }

    return false;
  }
}