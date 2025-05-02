import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reward.dart';
import '../../utils/constant.dart';

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardController>(
        init: RewardController(),
        builder: (controller) => Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: Get.back,
                          icon: Image.asset('assets/icon/left.png')
                      ),
                      Image.asset('assets/image/logo.png', width: 70)
                    ]
                )
            )
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            bottom: false,
            child: Obx(() => !controller.isLoading.value ? Center(
                child: CircularProgressIndicator(color: primaryColor)
            ) : Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView.builder(
                    itemCount: controller.rewards.length,
                    itemBuilder: (context, index) {
                      final item = controller.rewards[index];

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            SizedBox(
                                width: 80,
                                child: Text(
                                    item.date,
                                    style: TextStyle(
                                        fontSize: 14
                                    )
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    item.text,
                                    style: TextStyle(
                                        fontSize: 14
                                    )
                                )
                            ),
                            Expanded(
                                child: Text(
                                    item.reward,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    )
                                )
                            )
                          ]
                        )
                      );
                    })
            ))
        )
    ));
  }
}