import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/home/news.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';
import '../news/news.dart';
import 'package:get/get.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news, this.button});

  final NewsModel news;
  final bool? button;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => NewsView(id: news.id)),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: news.image,
                        errorWidget: (c, e, i) {
                          return Image.asset('assets/image/no_image.png');
                        },
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover
                    )
                ),
                h(8),
                Text(
                    news.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                ),
                h(4),
                news.time.isNotEmpty ? Row(
                    children: [
                      Image.asset('assets/icon/time.png'),
                      w(4),
                      Text(
                          news.time,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 11
                          )
                      )
                    ]
                ) : h(20),
                if (news.time.isNotEmpty) h(4),
                Text(
                    news.text,
                    style: TextStyle(
                        color: Color(0xFF1B1B1B),
                        fontSize: 11
                    ),
                    maxLines: !(button ?? false) ? 2 : 5,
                    overflow: TextOverflow.ellipsis
                ),
                if (!(button ?? false)) h(8),
                if (!(button ?? false)) ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        minimumSize: Size(double.infinity, 40)
                    ),
                    onPressed: () => Get.to(() => NewsView(id: news.id)),
                    child: Text('Читать', style: TextStyle(fontSize: 14, color: Colors.white))
                )
              ]
          )
      )
    );
  }
}