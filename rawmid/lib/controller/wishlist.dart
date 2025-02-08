import 'package:get/get.dart';
import 'package:rawmid/api/wishlist.dart';
import 'package:rawmid/controller/navigation.dart';
import '../model/home/product.dart';
import '../utils/helper.dart';

class WishlistController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt tab = 0.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  final navController = Get.find<NavigationController>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    products.clear();
    wishlist.value = Helper.prefs.getStringList('wishlist') ?? <String>[];

    if (wishlist.isNotEmpty) {
      isLoading.value = false;
      WishlistApi.getWishlist(wishlist.join(',')).then((e) {
        products.addAll(e);
        isLoading.value = true;
      });
    }
  }

  Future removeWishlist(String id) async {
    wishlist.remove(id);
    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
    products.removeWhere((e) => e.id == id);
  }
}