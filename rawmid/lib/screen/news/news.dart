import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/helper.dart';
import '../../controller/news.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/w.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
        init: NewsController(id),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(left: 3, right: 20),
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
                child: Obx(() => Stack(
                    alignment: Alignment.center,
                    children: [
                      if (controller.isLoading.value) Container(
                          height: Get.height,
                          color: Colors.white,
                          child: Column(
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
                                Expanded(
                                    child: controller.news.value != null ? SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            h(20),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: ShapeDecoration(
                                                            color: Color(0xFF1B1B1B),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                        ),
                                                        child: CachedNetworkImage(
                                                            imageUrl: controller.news.value!.image,
                                                            errorWidget: (c, e, i) {
                                                              return Image.asset('assets/image/no_image.png');
                                                            },
                                                            width: double.infinity,
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                    h(20),
                                                    Text(
                                                        controller.news.value!.title,
                                                        style: TextStyle(
                                                            color: Color(0xFF1E1E1E),
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700
                                                        )
                                                    ),
                                                    h(16),
                                                    Wrap(
                                                        spacing: 15,
                                                        children: [
                                                          Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Image.asset('assets/icon/calendar.png', width: 16),
                                                                w(4),
                                                                Text(
                                                                    controller.news.value!.date,
                                                                    textAlign: TextAlign.right,
                                                                    style: TextStyle(
                                                                        color: Color(0xFF8A95A8),
                                                                        fontSize: 14
                                                                    )
                                                                )
                                                              ]
                                                          ),
                                                          Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Image.asset('assets/icon/time.png', width: 16),
                                                                w(4),
                                                                Text(
                                                                    controller.news.value!.time,
                                                                    textAlign: TextAlign.right,
                                                                    style: TextStyle(
                                                                        color: Color(0xFF8A95A8),
                                                                        fontSize: 14
                                                                    )
                                                                )
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                  ]
                                              )
                                            ),
                                            h(20),
                                            if (controller.news.value!.text.isNotEmpty) Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Html(
                                                  data: controller.news.value!.text,
                                                  onLinkTap: (val, map, element) {
                                                    if ((val ?? '').isNotEmpty) {
                                                      Helper.openLink(val!);
                                                    }
                                                  }
                                              )
                                            )
                                          ]
                                      )
                                    ) : Center(
                                      child: Text('Статья не найдена!')
                                    )
                                )
                              ]
                          )
                      ),
                      if (controller.isLoading.value) SearchWidget(),
                      if (!controller.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor))
                    ]
                ))
            )
        )
    );
  }
}