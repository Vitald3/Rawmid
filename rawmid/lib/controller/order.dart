import 'package:get/get.dart';
import '../api/order.dart';
import '../model/order_history.dart';
import '../utils/helper.dart';
import 'navigation.dart';

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<OrdersModel> orders = <OrdersModel>[].obs;
  RxInt tab = 0.obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  final navController = Get.find<NavigationController>();
  RxString printStr = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    orders.value = await OrderApi.order();
    isLoading.value = true;
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

  Future setParam(int val, OrdersModel order) async {
    if (val == 1) {
      await navController.clear();

      for (var product in order.products) {
        await navController.addCart(product.id);
      }

      Get.back();
      Get.back();
      Get.back();
      navController.onItemTapped(4);
      Get.toNamed('/checkout');
    } else {
      Get.toNamed('/support', arguments: {'department_id': 0, 'order_id': order.id});
    }
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
    navController.wishlist.value = wishlist;
  }
}