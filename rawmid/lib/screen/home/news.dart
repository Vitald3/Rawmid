import 'package:flutter/material.dart';
import 'package:rawmid/utils/extension.dart';
import '../../model/home/news.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import 'news_card.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key, required this.news});

  final List<NewsModel> news;

  @override
  State<NewsSection> createState() => NewsSectionState();
}

class NewsSectionState extends State<NewsSection> {
  final pageController = PageController(viewportFraction: 1);
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ModuleTitle(title: 'Статьи', callback: () {}, type: true),
              ),
              h(15),
              Container(
                  padding: const EdgeInsets.only(left: 4, right: 20),
                  height: 264,
                  child: PageView.builder(
                      clipBehavior: Clip.none,
                      controller: pageController,
                      onPageChanged: (val) => setState(() {
                        activeIndex = val;
                      }),
                      itemCount: (widget.news.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(2, (colIndex) {
                              int productIndex = index * 2 + colIndex;

                              if (productIndex < widget.news.length) {
                                return Expanded(child: NewsCard(news: widget.news[productIndex]));
                              } else {
                                return Spacer();
                              }
                            })
                        );
                      }
                  )
              ),
              if (widget.news.length > 1) h(16),
              if (widget.news.length > 1) Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate((widget.news.length / 2).ceil(), (index) => GestureDetector(
                      onTap: () async {
                        await pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

                        setState(() {
                          activeIndex = index;
                        });
                      },
                      child: Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: activeIndex == index ? Colors.blue : Color(0xFF00ADEE).withOpacityX(0.2),
                              shape: BoxShape.circle
                          )
                      )
                  ))
              ),
              h(16)
            ]
        )
    );
  }
}
