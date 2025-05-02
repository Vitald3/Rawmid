import 'package:get/get.dart';
import 'package:rawmid/api/profile.dart';
import '../model/profile/reward.dart';

class RewardController extends GetxController {
  var isLoading = false.obs;
  var rewards = <RewardModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    rewards.value = await ProfileApi.rewards();
    isLoading.value = true;
  }
}