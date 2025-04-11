import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/club.dart';
import 'package:rawmid/controller/home.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/home/news.dart';
import 'package:rawmid/model/product/review.dart';
import '../api/login.dart';
import '../api/product.dart';
import '../api/wishlist.dart';
import '../model/home/product.dart';
import '../utils/helper.dart';

class ClubController extends GetxController {
  RxBool isLoading = false.obs;
  var home = Rxn<HomeController>();
  var nav = Rxn<NavigationController>();
  var banners = <Map<String, dynamic>>[].obs;
  final pageController = PageController(viewportFraction: 0.9);
  final reviewsController = PageController(viewportFraction: 0.947);
  var activeIndex = 0.obs;
  var reviews = <ReviewModel>[].obs;
  var recipes = <NewsModel>[].obs;
  var news = <NewsModel>[].obs;
  var products = <ProductModel>[].obs;
  var wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  var activeReviewsIndex = 0.obs;
  var isChecked = (-1).obs;
  var revHeight = 0.0.obs;
  var isComment = ''.obs;
  final formKey = GlobalKey<FormState>();
  var isQuestionComment = ''.obs;
  var rating = 4.obs;
  final fioReviewField = TextEditingController();
  final emailReviewField = TextEditingController();
  final textField = TextEditingController();
  final textReviewField = TextEditingController();
  var emailValidate = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    ClubApi.getClub().then((api) {
      if (api != null) {
        reviews.value = api.reviews;
        recipes.value = api.recipes;
        news.value = api.news;
      }

      banners.value = [
        {
          'title': 'Мои отзывы',
          'count': reviews.length,
          'icon': 'assets/icon/rev2.png',
          'image': 'assets/image/chat.png',
          'index': 0
        },
        {
          'title': 'Мои рецепты',
          'count': recipes.length,
          'icon': 'assets/icon/recep.png',
          'image': 'assets/image/vil.png',
          'index': 1
        },
        {
          'title': 'Мои статьи',
          'count': news.length,
          'icon': 'assets/icon/stat.png',
          'image': 'assets/image/tet.png',
          'index': 2
        }
      ];
    });

    home.value = Get.find<HomeController>();
    nav.value = Get.find<NavigationController>();

    products.clear();
    final wishlist = Helper.prefs.getStringList('wishlist') ?? <String>[];

    if (wishlist.isNotEmpty) {
      WishlistApi.getWishlist(wishlist.join(',')).then((e) {
        products.addAll(e);
      });
    }

    isLoading.value = true;
  }

  Future addWishlist(String id) async {
    if (wishlist.contains(id)) {
      wishlist.remove(id);
    } else {
      wishlist.add(id);
    }

    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
    Helper.trigger.value++;
    final main = Get.find<HomeController>();
    main.wishlist.value = wishlist;
  }

  String formatDateCustom(DateTime date) {
    List<String> months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];

    int day = date.day;
    String month = months[date.month - 1];
    int year = date.year;

    return "$day $month $year";
  }

  Future validateEmailX(String val) async {
    if (val.isNotEmpty && EmailValidator.validate(val)) {
      LoginApi.checkEmail(val).then((e) {
        emailValidate.value = !e;
      });
    } else {
      emailValidate.value = false;
    }
  }

  Future addReview(String id) async {
    if (formKey.currentState?.validate() ?? false) {
      bool api;

      if (isQuestionComment.isNotEmpty) {
        api = await ProductApi.addQuestionComment({
          'product_id': id,
          'qa_id': isQuestionComment.value,
          'name': fioReviewField.text,
          'text': textReviewField.text,
          'email': nav.value?.user.value?.email ?? emailReviewField.text
        });
      } else if (isComment.isNotEmpty) {
        api = await ProductApi.addComment({
          'product_id': id,
          'parent_id': isComment.value,
          'name': fioReviewField.text,
          'text': textReviewField.text,
          'email': nav.value?.user.value?.email ?? emailReviewField.text,
          'rating': '${rating.value}'
        });
      } else {
        api = await ProductApi.addReview({
          'product_id': id,
          'name': fioReviewField.text,
          'text': textReviewField.text,
          'email': nav.value?.user.value?.email ?? emailReviewField.text,
          'rating': '${rating.value}'
        });
      }

      if (api) {
        isComment.value = '';
        isQuestionComment.value = '';

        Timer.periodic(const Duration(seconds: 3), (t) {
          Get.back();
          textReviewField.clear();
          fioReviewField.clear();
          rating.value = 5;
          emailReviewField.clear();

          t.cancel();
        });
      }
    }
  }
}