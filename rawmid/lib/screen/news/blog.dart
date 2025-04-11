import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/home/news_card.dart';
import 'package:rawmid/screen/news/news.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/blog.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlogController>(
        init: BlogController(),
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
                              onPressed: () {
                                if (controller.id.isNotEmpty && controller.categories.isNotEmpty) {
                                  controller.id.value = '';
                                  return;
                                }

                                Get.back();
                              },
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
                child: Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                        child: Stack(
                            children: [
                              if (controller.isLoading.value) Container(
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
                                        Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                  child: Column(
                                                      children: [
                                                        h(20),
                                                        ModuleTitle(title: Get.parameters['my_recipes'] == '1' ? 'Мои рецепты' : Get.parameters['my_survey'] == '1' ? 'Мои статьи' : controller.isRecipe.value ? 'Рецепты' : 'Статьи', type: true)
                                                      ]
                                                  )
                                              ),
                                              if (controller.featured.isNotEmpty) Container(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  height: 254,
                                                  child: PageView.builder(
                                                      controller: controller.pageController,
                                                      onPageChanged: (val) {
                                                        controller.activeIndex.value = val;
                                                      },
                                                      itemCount: controller.featured.length,
                                                      padEnds: false,
                                                      itemBuilder: (context, index) {
                                                        return Padding(
                                                            padding: const EdgeInsets.only(right: 20),
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                      clipBehavior: Clip.antiAlias,
                                                                      height: 160,
                                                                      decoration: ShapeDecoration(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                                      ),
                                                                      child: Stack(
                                                                          children: [
                                                                            CachedNetworkImage(
                                                                                imageUrl: controller.featured[index].image,
                                                                                errorWidget: (c, e, i) {
                                                                                  return Image.asset('assets/image/no_image.png');
                                                                                },
                                                                                width: double.infinity,
                                                                                fit: BoxFit.contain
                                                                            ),
                                                                            Positioned(
                                                                                left: 0,
                                                                                top: 0,
                                                                                right: 0,
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        gradient: LinearGradient(
                                                                                            begin: Alignment(-0.00, -1.00),
                                                                                            end: Alignment(0, 1),
                                                                                            colors: [Colors.black.withOpacityX(0), Colors.black.withOpacityX(0.800000011920929)]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            ),
                                                                            Positioned(
                                                                                left: 16,
                                                                                right: 16,
                                                                                bottom: 14,
                                                                                child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Flexible(
                                                                                          child: Text(
                                                                                              controller.featured[index].title,
                                                                                              maxLines: 2,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                  fontSize: 16,
                                                                                                  height: 1,
                                                                                                  fontWeight: FontWeight.w700
                                                                                              )
                                                                                          )
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: primaryColor,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(12)
                                                                                              ),
                                                                                              minimumSize: Size(90, 40)
                                                                                          ),
                                                                                          onPressed: () => Get.to(() => NewsView(id: controller.featured[index].id, recipe: false)),
                                                                                          child: Text('Читать', style: TextStyle(fontSize: 14, color: Colors.white))
                                                                                      )
                                                                                    ]
                                                                                )
                                                                            )
                                                                          ]
                                                                      )
                                                                  ),
                                                                  h(16),
                                                                  Text(
                                                                      controller.featured[index].text,
                                                                      maxLines: 4,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                          color: Color(0xFF1E1E1E),
                                                                          fontSize: 13
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        );
                                                      }
                                                  )
                                              ),
                                              if (controller.featured.length > 1) h(16),
                                              if (controller.featured.length > 1) Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: List.generate(controller.featured.length, (index) => GestureDetector(
                                                      onTap: () async {
                                                        await controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

                                                        controller.activeIndex.value = index;
                                                      },
                                                      child: Container(
                                                          width: 10,
                                                          height: 10,
                                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                                          decoration: BoxDecoration(
                                                              color: controller.activeIndex.value == index ? Colors.blue : Color(0xFF00ADEE).withOpacityX(0.2),
                                                              shape: BoxShape.circle
                                                          )
                                                      )
                                                  ))
                                              ),
                                              if (controller.featured.isNotEmpty) h(30),
                                              controller.categories.isNotEmpty && controller.id.isEmpty ? GridView.builder(
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 24,
                                                      crossAxisSpacing: 12,
                                                      childAspectRatio: 1,
                                                      mainAxisExtent: 165
                                                  ),
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  itemCount: controller.categories.length,
                                                  itemBuilder: (context, index) => GestureDetector(
                                                    onTap: () => controller.setCategory(controller.categories[index].id),
                                                    child: Container(
                                                        width: double.infinity,
                                                        height: 165,
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                            color: const Color(0xFFE4E4E4),
                                                            borderRadius: BorderRadius.circular(8),
                                                            image: DecorationImage(image: CachedNetworkImageProvider(controller.categories[index].image), fit: BoxFit.cover)
                                                        ),
                                                        child: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Positioned(
                                                                  left: 0,
                                                                  top: 0,
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  child: ColoredBox(color: Colors.black.withOpacityX(0.6))
                                                              ),
                                                              Text(
                                                                  controller.categories[index].name,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w700
                                                                  )
                                                              )
                                                            ]
                                                        )
                                                    )
                                                  )
                                              ) : GridView.builder(
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 15,
                                                      childAspectRatio: 1,
                                                      mainAxisExtent: 264
                                                  ),
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  itemCount: controller.news.length,
                                                  itemBuilder: (context, index) => NewsCard(news: controller.news[index], recipe: controller.isRecipe.value)
                                              ),
                                              h(20 + MediaQuery.of(context).viewPadding.bottom)
                                            ]
                                        )
                                      ]
                                  )
                              ),
                              if (controller.isLoading.value) SearchWidget()
                            ]
                        )
                    ),
                    if (!controller.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor))
                  ]
                ))
            )
        )
    );
  }
}