import 'package:rawmid/model/home/product.dart';

class MyReviewModel {
  late String id;
  late String author;
  DateTime? date;
  late String text;
  late int rating;
  late List<MyReviewModel> comments;
  late ProductModel product;
  late bool parent;
  bool checked = false;

  MyReviewModel({required this.id, required this.author, this.date, required this.text, required this.rating, required this.comments, required this.product, required this.parent});

  MyReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    date = DateTime.tryParse('${json['date_added']}');
    text = json['text'];
    rating = json['rating'];
    parent = json['parent'];
    comments = <MyReviewModel>[];
    if (json['comments'] != null) {
      for (var i in json['comments']) {
        comments.add(MyReviewModel.fromJson(i));
      }
    }
    product = ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['author'] = author;
    data['date'] = date;
    data['text'] = text;
    data['rating'] = rating;
    data['parent'] = parent;
    data['comments'] = comments;
    data['product'] = product;
    return data;
  }
}