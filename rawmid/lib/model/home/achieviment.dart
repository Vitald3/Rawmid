import 'package:rawmid/model/home/rank.dart';

class AchievimentModel {
  late String name;
  late int rang;
  late int max;
  late List<RankModel> ranks;

  AchievimentModel({required this.name, required this.rang, required this.max, required this.ranks});

  AchievimentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rang = json['rang'];
    max = json['max'];

    if (json['ranks'] != null) {
      for (var i in json['ranks']) {
        ranks.add(RankModel.fromJson(i));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['rang'] = rang;
    data['max'] = max;
    data['ranks'] = ranks;
    return data;
  }
}