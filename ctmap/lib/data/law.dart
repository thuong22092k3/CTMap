class Chapter {
  final String title;
  final List<Article> articles;

  Chapter({required this.title, required this.articles});
}

class Article {
  final String title;
  final String content;

  Article({required this.title, required this.content});
}