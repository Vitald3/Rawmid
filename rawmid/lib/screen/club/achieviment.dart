import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/club.dart';
import '../../model/club/achievement.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';

class AchievimentView extends GetView<ClubController> {
  const AchievimentView({super.key});

  @override
  Widget build(BuildContext context) {
    var colorIndex = 0;
    var colorIndex2 = 0;
    final auth = controller.nav.value?.user.value != null;
    final items = controller.home.value?.achieviment.value?.achievements ?? [];
    final items2 = controller.home.value?.achieviment.value?.notAchievements ?? [];
    final rang = controller.home.value?.achieviment.value?.rang ?? 0;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: Padding(
                padding: const EdgeInsets.only(left: 4, right: 20),
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
            child: Obx(() => controller.isLoading.value ? SingleChildScrollView(
                child: Stack(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredBox(
                                color: Color(0xFFF0F0F0),
                                child: Column(
                                    children: [
                                      h(20),
                                      SearchBarView(),
                                      h(20)
                                    ]
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      h(16),
                                      ModuleTitle(title: 'Достижения', type: true),
                                      Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment(0.25, -0.73),
                                              end: Alignment(0.88, 0.79),
                                              colors: [const Color(0xFF007FE2), const Color(0xFF0452C6)]
                                            ),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                          ),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                right: -74,
                                                top: 104,
                                                child: Container(
                                                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-0.45),
                                                  width: 335.74,
                                                  height: 110,
                                                  decoration: ShapeDecoration(
                                                    color: const Color(0xFF1475FF).withOpacityX(0.6),
                                                    shape: OvalBorder()
                                                  )
                                                )
                                              ),
                                              Column(
                                                spacing: 4,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Баланс бонусных балов',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.30
                                                    )
                                                  ),
                                                  Row(
                                                    spacing: 6,
                                                    children: [
                                                      Text(
                                                        '$rang',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 40,
                                                          fontWeight: FontWeight.w600
                                                        )
                                                      ),
                                                      Image.asset('assets/icon/rang2.png', width: 35)
                                                    ]
                                                  ),
                                                  h(20),
                                                  Text(
                                                    items[1].text.join('\n'),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12
                                                    )
                                                  )
                                                ]
                                              )
                                            ]
                                          )
                                      ),
                                      h(24),
                                      Row(
                                          spacing: 4,
                                          children: [
                                            Text(
                                                'Ваш ранг:',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Color(0xFF8A95A8),
                                                    fontSize: 14
                                                )
                                            ),
                                            Text(
                                                controller.home.value?.achieviment.value!.name ?? '',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Color(0xFF1E1E1E),
                                                    fontSize: 14
                                                )
                                            )
                                          ]
                                      ),
                                      h(8),
                                      if (items.isNotEmpty && auth) Stack(
                                          children: [
                                            Container(
                                                height: 35,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue.shade200,
                                                    borderRadius: BorderRadius.circular(34)
                                                )
                                            ),
                                            Container(
                                                height: 35,
                                                width: Get.width * (rang / (controller.home.value?.achieviment.value!.max ?? 0)),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(34),
                                                ),
                                                alignment: Alignment.center
                                            ),
                                            Positioned(
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    spacing: 3,
                                                    children: [
                                                      Row(
                                                          spacing: 4,
                                                          children: [
                                                            Text(
                                                                '$rang',
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            ),
                                                            Image.asset('assets/icon/rang.png')
                                                          ]
                                                      ),
                                                      Text(
                                                          '/',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                          )
                                                      ),
                                                      Row(
                                                          spacing: 4,
                                                          children: [
                                                            Text(
                                                                '${controller.home.value!.achieviment.value!.max}',
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            ),
                                                            Image.asset('assets/icon/rang.png')
                                                          ]
                                                      )
                                                    ]
                                                )
                                            )
                                          ]
                                      ),
                                      if (items.isNotEmpty && auth) h(40),
                                      if (items.isNotEmpty && auth) ModuleTitle(title: 'Полученные награды', type: true)
                                    ]
                                )
                            ),
                            if (items.isNotEmpty && auth) SizedBox(
                                height: 192,
                                child: PageView.builder(
                                    controller: PageController(viewportFraction: 0.5, initialPage: items.length-2),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      colorIndex++;
                                      return _buildAchievementCard(items[index], colorIndex);
                                    }
                                )
                            ),
                            if (items2.isNotEmpty && auth) h(40),
                            if (items2.isNotEmpty && auth) Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ModuleTitle(title: 'Близки к получению', type: true)
                                    ]
                                )
                            ),
                            if (items2.isNotEmpty && auth) SizedBox(
                                height: 192,
                                child: PageView.builder(
                                    controller: PageController(viewportFraction: 0.5, initialPage: items2.length == 1 ? 0 : 1),
                                    itemCount: items2.length,
                                    itemBuilder: (context, index) {
                                      colorIndex2++;
                                      return _buildAchievementCard(items2[index], colorIndex2);
                                    }
                                )
                            ),
                            h(20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                                controller.nav.value!.onItemTapped(0);
                                Get.back();
                                Get.back();
                              })
                            ),
                            h(20 + MediaQuery.of(context).viewPadding.bottom),
                          ]
                      ),
                      SearchWidget()
                    ]
                )) : Center(
                child: CircularProgressIndicator(color: primaryColor)
            ))
        )
    );
  }

  Widget _buildAchievementCard(AchievementModel e, int colorIndex) {
    List<AssetImage> cardColors = [AssetImage('assets/image/award1.png'), AssetImage('assets/image/award2.png'), AssetImage('assets/image/award3.png')];

    return Container(
        width: 160,
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          image: DecorationImage(image: cardColors[colorIndex % cardColors.length], fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: CachedNetworkImage(
                      imageUrl: e.image,
                      errorWidget: (c, e, i) {
                        return Image.asset('assets/image/no_image.png');
                      }
                  )
              ),
              h(8),
              Text(e.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              h(4),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Text(
                        '${e.reward}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                        )
                    ),
                    Image.asset('assets/icon/rang.png')
                  ]
              )
            ]
        )
    );
  }
}