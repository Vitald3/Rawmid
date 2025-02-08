class ProductModel {
  late String id;
  late String title;
  late String image;
  late String category;
  late String color;
  int? rating;
  String? price;
  String? special;

  ProductModel({required this.id, required this.title, required this.image, required this.category, required this.color, this.rating, this.price, this.special});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'];
    image = json['image'];
    category = json['category'];
    color = json['color'];
    rating = json['rating'];
    price = json['price'];
    special = json['special'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = title;
    data['image'] = image;
    data['category'] = category;
    data['color'] = color;
    data['rating'] = rating;
    data['price'] = price;
    data['special'] = special;
    return data;
  }
}