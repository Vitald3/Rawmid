import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/home/news.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news});

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 16),
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
                      fit: BoxFit.fill
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
              if (news.time.isNotEmpty) Row(
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
              ),
              if (news.time.isNotEmpty) h(4),
              Text(
                  news.text,
                  style: TextStyle(
                    color: Color(0xFF1B1B1B),
                    fontSize: 11
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
              ),
              h(8),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      minimumSize: Size(double.infinity, 40)
                  ),
                  onPressed: () {},
                  child: Text('Читать', style: TextStyle(fontSize: 14, color: Colors.white))
              )
            ]
        )
    );
  }
}