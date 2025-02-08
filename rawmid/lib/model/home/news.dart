class NewsModel {
  late String id;
  late String title;
  late String image;
  late String text;
  late String time;
  late String link;

  NewsModel({required this.id, required this.title, required this.image, required this.text, required this.time, required this.link});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    text = json['text'];
    time = getReadingTime(json['text']);
    link = json['link'];
  }

  String getReadingTime(String text, {int wpm = 200}) {
    String cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll(RegExp(r'\s+'), ' ').trim();

    List<String> words = RegExp(r'\b[А-Яа-яA-Za-z0-9]+\b', unicode: true)
        .allMatches(cleanText)
        .map((match) => match.group(0)!)
        .toList();

    int wordCount = words.length;

    if (wordCount == 0) return '';

    int totalSeconds = (wordCount / (wpm / 60)).round();

    if (totalSeconds >= 3600) {
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return "$hours ч. $minutes мин.";
    }

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return minutes > 0 ? "$minutes мин. $seconds сек." : "$seconds сек.";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['text'] = text;
    data['time'] = time;
    data['link'] = link;
    return data;
  }
}