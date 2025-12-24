import '../models/news_article.dart';

class BookmarkRepository {
  // Singleton pattern
  static final BookmarkRepository _instance = BookmarkRepository._internal();
  factory BookmarkRepository() => _instance;
  BookmarkRepository._internal();

  // Bookmarks storage
  final List<NewsArticle> _bookmarks = [];

  List<NewsArticle> getBookmarks() {
    return List.from(_bookmarks);
  }

  bool isBookmarked(NewsArticle article) {
    return _bookmarks.any((item) => item.url == article.url);
  }

  void addBookmark(NewsArticle article) {
    if (!isBookmarked(article)) {
      _bookmarks.add(article);
    }
  }

  void removeBookmark(NewsArticle article) {
    _bookmarks.removeWhere((item) => item.url == article.url);
  }

  void toggleBookmark(NewsArticle article) {
    if (isBookmarked(article)) {
      removeBookmark(article);
    } else {
      addBookmark(article);
    }
  }

  int get bookmarkCount => _bookmarks.length;
}
