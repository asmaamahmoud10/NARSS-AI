bool checkCommentRelevance(String comment) {
  String text = comment.toLowerCase();

  List<String> bannedWords = [
    "http",
    "www",
    "buy now",
    "free money",
    "money",
    "click here",
    "subscribe",
    "offer",
    "discount",
  ];

  for (var word in bannedWords) {
    if (text.contains(word)) {
      return false;
    }
  }

  return true;
}
