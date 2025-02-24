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

const siteUrl = 'https://madeindream.com';
const apiUrl = '$siteUrl/index.php?route=api/app';
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
const questionsUrl = '$apiUrl/questions';
const setAddressUrl = '$apiUrl/setAddress';
const saveAddressUrl = '$apiUrl/saveAddress';
const uploadAvatarUrl = '$apiUrl/uploadAvatar';
const supportUrl = '$apiUrl/support';
const getWishlistUrl = '$apiUrl/getWishlist';
const comparesUrl = '$apiUrl/compares';
const getBlogUrl = '$apiUrl/blog';
const getNewUrl = '$apiUrl/getNew';
const getOrdersUrl = '$apiUrl/orders';
const getBannerUrl = '$apiUrl/banners';
const getRanksUrl = '$apiUrl/getRanks';
const getUrlTypeUrl = '$apiUrl/getUrlType';
const getFeaturedUrl = '$apiUrl/getFeatured';
const getSernumUrl = '$apiUrl/getSernum';
const getRecordsUrl = '$apiUrl/getRecords';
const getNewsUrl = '$apiUrl/getNews';
const getRecipesUrl = '$apiUrl/getRecipes';
const searchUrl = '$apiUrl/search';
const categoriesUrl = '$apiUrl/categories';
const specialUrl = '$apiUrl/specials';
const categoryUrl = '$apiUrl/category';
const loadProductsUrl = '$apiUrl/getFilterProducts';
const addCartUrl = '$apiUrl/addCart';
const clearUrl = '$apiUrl/clearCart';
const cartProductsUrl = '$apiUrl/getCartProducts';
const updateCartUrl = '$apiUrl/updateCart';
const productUrl = '$apiUrl/product';
const addChainCartUrl = '$apiUrl/addChainCart';
const getDiscountsUrl = '$apiUrl/discounts';
const getAccessoriesUrl = '$apiUrl/accessories';
const getReviewsUrl = '$apiUrl/reviews';
const getMyReviewsUrl = '$apiUrl/my_reviews';
const addQuestionUrl = '$apiUrl/addQuestion';
const addQuestionOtherUrl = '$apiUrl/addQuestionOther';
const addReviewUrl = '$apiUrl/addReview';
const addCommentUrl = '$apiUrl/addComment';
const addQuestionCommentUrl = '$apiUrl/addQuestionComment';
const addXUrl = '$apiUrl/addX';
const getAccProductsUrl = '$apiUrl/getAccProducts';
const getCheckoutUrl = '$apiUrl/checkout';
const setCheckoutUrl = '$apiUrl/setCheckout';
const checkoutUrl = '$apiUrl/order';
const bbPvzUrl = '$siteUrl/index.php?route=checkout/bb/select_pvz';
const getBbPvzUrl = '$siteUrl/index.php?route=checkout/bb/getPvzMapPoints';
const ocoXUrl = '$apiUrl/osobie';
const paymentUrl = '$apiUrl/payment';
const personalDataUrl = '$siteUrl/informatsija/politika-obrabotki.html?ajax=1';
const uslUrl = '$siteUrl/index.php?route=catalog/record/update&token=d823f7ecbb4e601ea025cffcac5b4d83&record_id=104&filter_name=%D1%83%D1%81%D0%BB%D0%BE%D0%B2%D0%B8%D1%8F';
const searchCityUrl = '$siteUrl/index.php?route=module/geoip/search&term=';