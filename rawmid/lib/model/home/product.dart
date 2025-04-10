class ProductModel {
  late String id;
  late String title;
  late String image;
  late String category;
  late String color;
  late String model;
  int? rating;
  int? sortOrder;
  String? price;
  String? special;
  List<String>? images;

  ProductModel({required this.id, required this.title, required this.image, required this.category, required this.color, required this.model, this.rating, this.sortOrder, this.price, this.special, this.images});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'];
    image = json['image'];
    category = json['category'];
    color = json['color'];
    rating = json['rating'];
    sortOrder = json['sort_order'];
    price = '${json['price'] != 0 ? json['price'] : ''}';
    special = '${json['special'] != 0 ? json['special'] : ''}';
    images = <String>[];

    if (json['images'] != null) {
      for (var i in json['images']) {
        images!.add(i);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = title;
    data['image'] = image;
    data['category'] = category;
    data['color'] = color;
    data['rating'] = rating;
    data['sort_order'] = sortOrder;
    data['price'] = price;
    data['special'] = special;
    data['images'] = images;
    return data;
  }
}