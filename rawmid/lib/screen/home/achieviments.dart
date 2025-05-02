import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/model/club/achievement.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../model/home/achieviment.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/tooltip.dart';
import '../../widget/w.dart';
import 'package:get/get.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key, required this.item, required this.callback});

  final AchievimentModel item;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    int colorIndex = 0;
    int rIndex = 1;

    for (var (index, i) in item.achievements.indexed) {
      if ((int.tryParse('${i.reward}') ?? 0) >= item.rang) {
        rIndex = index - 1;
        break;
      }
    }

    if (rIndex < 0) {
      rIndex = 1;
    }

    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ModuleTitle(title: 'Достижения', callback: callback, type: true),
                Row(
                    children: [
                      Text(
                          'Ваш ранг:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 14
                          )
                      ),
                      w(4),
                      Text(
                          item.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 14
                          )
                      )
                    ]
                ),
                h(8),
                TooltipWidget(
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
                              width: Get.width * (item.rang / item.max),
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
                                  children: [
                                    Row(
                                        children: [
                                          Text(
                                              '${item.rang}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              )
                                          ),
                                          w(4),
                                          Image.asset('assets/icon/rang.png')
                                        ]
                                    ),
                                    w(3),
                                    Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        )
                                    ),
                                    w(3),
                                    Row(
                                        children: [
                                          Text(
                                              '${item.max}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              )
                                          ),
                                          w(4),
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
                })
              ]
            )
          ),
          if (item.achievements.isNotEmpty) h(30),
          if (item.achievements.isNotEmpty) SizedBox(
            height: 192,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.5, initialPage: rIndex),
              itemCount: item.achievements.length,
              itemBuilder: (context, index) {
                colorIndex++;
                return _buildAchievementCard(item.achievements[index], colorIndex);
              }
            )
          ),
          if (item.achievements.isNotEmpty) h(30)
        ]
      )
    );
  }

  Widget _buildAchievementCard(AchievementModel e, int colorIndex) {
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
            )
        )
    );
  }
}
