class NewsModel {
  late String id;
  late String title;
  late String image;
  late String text;
  late String time;
  late String date;
  late String link;
  String? moderate;
  bool? recipe;
  bool? survey;

  NewsModel({required this.id, required this.title, required this.image, required this.text, required this.date, required this.time, required this.link, this.moderate, this.recipe, this.survey});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    text = json['text'];
    date = json['date_added'];
    time = getReadingTime(json['text2'] ?? json['text']);
    link = json['link'];
    moderate = json['moderate'];
    recipe = json['recipe'] ?? false;
    survey = json['survey'] ?? false;
  }

  String getReadingTime(String text, {int wpm = 280}) {
    String cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '');

    Map<String, String> htmlEntities = {
      '&nbsp;': ' ',
      '&lt;': '<',
      '&gt;': '>',
      '&amp;': '&',
      '&quot;': '"',
      '&#39;': "'",
    };
    htmlEntities.forEach((key, value) {
      cleanText = cleanText.replaceAll(key, value);
    });

    cleanText = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();

    List<String> words = RegExp(r'[А-Яа-яA-Za-z0-9]+', unicode: true)
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

    return minutes > 0 ? "$minutes мин.${seconds > 0 ? ' $seconds сек.' : ''}" : '$seconds сек.';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['text'] = text;
    data['date_added'] = date;
    data['time'] = time;
    data['link'] = link;
    data['moderate'] = moderate;
    data['recipe'] = recipe;
    data['survey'] = survey;
    return data;
  }
}