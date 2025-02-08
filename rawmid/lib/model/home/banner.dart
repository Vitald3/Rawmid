class BannerModel {
  late String title;
  late String image;
  late String image2;
  late String link;

  BannerModel({required this.title, required this.image, required this.image2, required this.link});

  BannerModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    image2 = json['image2'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['image2'] = image2;
    data['link'] = link;
    return data;
  }
}