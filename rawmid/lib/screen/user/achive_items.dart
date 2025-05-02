import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/h.dart';
import '../../model/club/achievement.dart';

class AchiveItemsView extends StatelessWidget {
  const AchiveItemsView({super.key, required this.items, required this.type});

  final List<AchievementModel> items;
  final bool type;

  @override
  Widget build(BuildContext context) {
    List<AssetImage> cardColors = [AssetImage('assets/image/award1.png'), AssetImage('assets/image/award2.png'), AssetImage('assets/image/award3.png')];
    var colorIndex = 0;

    return Scaffold(
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
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 8,
                        mainAxisExtent: type ? 200 : 162
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      colorIndex++;

                      return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: Get.context!,
                                builder: (context) => Dialog(
                                    backgroundColor: Colors.white,
                                    insetPadding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 30,
                                              child: CachedNetworkImage(
                                                  imageUrl: item.image,
                                                  width: 200,
                                                  height: 200,
                                                  errorWidget: (c, e, i) {
                                                    return Image.asset('assets/image/no_image.png');
                                                  }
                                              )
                                          ),
                                          h(8),
                                          Text(
                                              item.title,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                          ),
                                          h(8),
                                          Text(
                                              item.text.join("\r\n"),
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    )
                                )
                            );
                          },
                          child: Container(
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
                                                  imageUrl: item.image,
                                                  errorWidget: (c, e, i) {
                                                    return Image.asset('assets/image/no_image.png');
                                                  }
                                              )
                                          ),
                                          h(8),
                                          Text(item.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                                          if (item.reward > 0) h(4),
                                          if (item.reward > 0) Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              spacing: 4,
                                              children: [
                                                Text(
                                                    '${item.reward}',
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
                                                  width: 160 * ((item.progress?.current ?? 0) / (item.progress?.max ?? 1)),
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
                                                      'Выполнено ${(item.progress?.current ?? 0)} из ${(item.progress?.max ?? 0)}',
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
                    })
            )
        )
    );
  }
}