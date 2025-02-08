import 'package:flutter/material.dart';

const appName = 'Rawmid';
const primaryColor = Color(0xFF14BFFF);
const dangerColor = Color(0xFFF43B4E);
const firstColor = Color(0xFF1E1E1E);
const secondColor = Color(0xFF8A95A8);

var theme = ThemeData(
    fontFamily: 'Manrope',
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionHandleColor: primaryColor
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: firstColor),
      displayMedium: TextStyle(color: firstColor),
      bodyMedium: TextStyle(color: firstColor),
      titleMedium: TextStyle(color: firstColor),
    )
);

const apiUrl = 'https://msk.madeindream.com/index.php?route=api/app';
const registerUrl = '$apiUrl/register';
const loginUrl = '$apiUrl/login';
const loginCodeUrl = '$apiUrl/loginCode';
const userUrl = '$apiUrl/getUser';
const userDeleteUrl = '$apiUrl/user_delete';
const logoutUrl = '$apiUrl/logout';
const sendCodeUrl = '$apiUrl/sendCode';
const changePassUrl = '$apiUrl/changePass';
const setNewsletterUrl = '$apiUrl/changeNewsletter';
const setPushUrl = '$apiUrl/changePush';
const saveUrl = '$apiUrl/save';
const countriesUrl = '$apiUrl/countries';
const setAddressUrl = '$apiUrl/setAddress';
const saveAddressUrl = '$apiUrl/saveAddress';
const uploadAvatarUrl = '$apiUrl/uploadAvatar';
const getWishlistUrl = '$apiUrl/getWishlist';
const getBannerUrl = '$apiUrl/getBanner';
const getRanksUrl = '$apiUrl/getRanks';
const getUrlProductUrl = '$apiUrl/getProductId';
const getFeaturedUrl = '$apiUrl/getFeatured';
const getSernumUrl = '$apiUrl/getSernum';
const getRecordsUrl = '$apiUrl/getRecords';
const getNewsUrl = '$apiUrl/getNews';
const getRecipesUrl = '$apiUrl/getRecipes';