import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/model/home/rank.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../model/home/achieviment.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';
import 'package:get/get.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key, required this.item, required this.callback});

  final AchievimentModel item;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    int colorIndex = 0;
    int rIndex = 0;

    for (var (index, i) in item.ranks.indexed) {
      if (int.parse('${i.rewards ?? 0}') >= item.rang) {
        rIndex = index - 1;
        break;
      }
    }

    if (rIndex < 0) {
      rIndex = 0;
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
                Stack(
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
              ]
            )
          ),
          if (item.ranks.isNotEmpty) h(30),
          if (item.ranks.isNotEmpty) SizedBox(
            height: 192,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.5, initialPage: rIndex),
              itemCount: item.ranks.length,
              itemBuilder: (context, index) {
                colorIndex++;
                return _buildAchievementCard(item.ranks[index], colorIndex);
              }
            )
          ),
          if (item.ranks.isNotEmpty) h(30)
        ]
      )
    );
  }

  Widget _buildAchievementCard(RankModel e, int colorIndex) {
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
                      imageUrl: e.image ?? '',
                      errorWidget: (c, e, i) {
                        return Image.asset('assets/image/no_image.png');
                      }
                  )
              ),
              h(8),
              Text(e.title ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              h(4),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${e.rewards}',
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
              h(4),
              Text(e.description ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 12)
              )
            ]
        )
    );
  }
}
