import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/club.dart';
import '../../model/club/achievement.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/tooltip.dart';
import '../user/achive_items.dart';

class AchievimentView extends StatelessWidget {
  const AchievimentView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ClubController>()) {
      Get.put(ClubController());
    }

    final controller = Get.find<ClubController>();

    var colorIndex = 0;
    var colorIndex2 = 0;

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
            child: Obx(() {
              final auth = controller.user.value != null;
              final items = controller.achievements;
              final items2 = controller.notAchievements;
              final rang = controller.user.value?.rang ?? 0;

              return controller.isLoading.value ? SingleChildScrollView(
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
                                        GestureDetector(
                                          onTap: () => Get.toNamed('/rewards'),
                                          child: Container(
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
                                                              'Выполняйте задания, пишите обзоры, рецепты и прочее, получайте за это баллы и покупайте на них товары RAWMID',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12
                                                              )
                                                          )
                                                        ]
                                                    )
                                                  ]
                                              )
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
                                                  controller.user.value?.rangStr ?? 'Новичок',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 14
                                                  )
                                              )
                                            ]
                                        ),
                                        h(8),
                                        if (items.isNotEmpty && auth) TooltipWidget(
                                            message: 'Набрано Вами баллов / Количество баллов до следующего ранга.',
                                            left: 20,
                                            child: Stack(
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
                                                      width: Get.width * (rang / 12000),
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
                                                                      '12000',
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
                                            )
                                        ),
                                        h(10),
                                        PrimaryButton(text: 'Как получить баллы?', height: 38, onPressed: () {
                                          showDialog(
                                              context: Get.context!,
                                              builder: (context) => Dialog(
                                                  backgroundColor: Colors.white,
                                                  insetPadding: EdgeInsets.symmetric(horizontal: 20),
                                                  child: Padding(
                                                      padding: EdgeInsets.all(20),
                                                      child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'За что можно получить баллы?',
                                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                                                  ),
                                                                  Transform.translate(
                                                                    offset: Offset(15, 0),
                                                                    child: IconButton(
                                                                        icon: const Icon(Icons.close),
                                                                        onPressed: Get.back
                                                                    )
                                                                  )
                                                                ]
                                                            ),
                                                            const Divider(height: 1),
                                                            h(20),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Действие',
                                                                      style: TextStyle(fontWeight: FontWeight.bold)
                                                                  ),
                                                                  Text(
                                                                      'Начислим',
                                                                      style: TextStyle(fontWeight: FontWeight.bold)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Отзыв',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '150',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Отзыв с 2 фото и более',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '300',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Отзыв с 4 фото и более',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '500',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Посещение клуба (в день)',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '25',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Публикация статьи',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '200',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Публикация рецепта',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '150',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Публикация обзора',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '250',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Вопрос',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '30',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Комментарий',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '25',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Вступление в клуб',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '200',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            ),
                                                            h(10),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Подписка на новости (в мес)',
                                                                      style: TextStyle(fontSize: 14)
                                                                  ),
                                                                  Text(
                                                                      '100',
                                                                      style: TextStyle(fontSize: 14)
                                                                  )
                                                                ]
                                                            )
                                                          ]
                                                      )
                                                  )
                                              )
                                          );
                                        }),
                                        if (items.isNotEmpty && auth) h(40),
                                        if (items.isNotEmpty && auth) ModuleTitle(title: 'Полученные награды', type: true)
                                      ]
                                  )
                              ),
                              if (items.isNotEmpty && auth) SizedBox(
                                  height: 192,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: items.length,
                                    padding: EdgeInsets.only(left: 14),
                                    itemBuilder: (context, index) {
                                      colorIndex++;
                                      return _buildAchievementCard(items[index], colorIndex, false);
                                    }
                                  )
                              ),
                              if (items.isNotEmpty && auth) h(20),
                              if (items.isNotEmpty && auth) Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: PrimaryButton(text: 'Смотреть все', height: 38, onPressed: () => Get.to(() => AchiveItemsView(items: items, type: false)))
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
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items2.length,
                                      padding: EdgeInsets.only(left: 14),
                                      itemBuilder: (context, index) {
                                        colorIndex2++;
                                        return _buildAchievementCard(items2[index], colorIndex2, false);
                                      }
                                  )
                              ),
                              if (items.isNotEmpty && auth) h(20),
                              if (items.isNotEmpty && auth) Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: PrimaryButton(text: 'Смотреть все', height: 38, onPressed: () => Get.to(() => AchiveItemsView(items: items2, type: true)))
                              ),
                              h(20),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                                    final main = Get.find<NavigationController>();
                                    main.onItemTapped(0);
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
              );
            })
        )
    );
  }

  Widget _buildAchievementCard(AchievementModel e, int colorIndex, bool type) {
    List<AssetImage> cardColors = [AssetImage('assets/image/award1.png'), AssetImage('assets/image/award2.png'), AssetImage('assets/image/award3.png')];

    return GestureDetector(
      onTap: () {
        showDialog(
          context: Get.context!,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: CachedNetworkImage(
                      imageUrl: e.image,
                      width: 200,
                      height: 200,
                      errorWidget: (c, e, i) {
                        return Image.asset('assets/image/no_image.png');
                      }
                    )
                  ),
                  h(8),
                  Text(
                    e.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  ),
                  h(8),
                  Text(
                    e.text.join("\r\n"),
                    style: TextStyle(fontSize: 14)
                  )
                ]
              )
            )
          )
        );
      },
      child: Container(
          width: 160,
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            image: DecorationImage(image: cardColors[colorIndex % cardColors.length], fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
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
                    if (e.reward > 0) h(4),
                    if (e.reward > 0) Row(
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
              ),
              if (type) Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                    children: [
                      Container(
                          height: 24,
                          width: 160,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                      Container(
                          height: 24,
                          width: 160 * ((e.progress?.current ?? 0) / (e.progress?.max ?? 1)),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center
                      ),
                      Positioned(
                          top: 2,
                          bottom: 0,
                          left: 4,
                          right: 4,
                          child: Text(
                              'Выполнено ${(e.progress?.current ?? 0)} из ${(e.progress?.max ?? 0)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              )
                          )
                      )
                    ]
                )
              )
            ]
          )
      )
    );
  }
}