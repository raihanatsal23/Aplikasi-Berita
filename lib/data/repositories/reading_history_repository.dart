import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_article.dart';

class ReadingHistoryRepository {
  static final ReadingHistoryRepository _instance =
      ReadingHistoryRepository._internal();
  factory ReadingHistoryRepository() => _instance;
  ReadingHistoryRepository._internal();

  static const String _historyKey = 'reading_history';
  static const int _maxHistoryItems = 100;

  Future<List<NewsArticle>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];

    return historyJson
        .map((json) => NewsArticle.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addToHistory(NewsArticle article) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];

    // Remove if already exists
    historyJson.removeWhere((json) {
      final existing = NewsArticle.fromJson(jsonDecode(json));
      return existing.url == article.url;
    });

    // Add to beginning
    historyJson.insert(0, jsonEncode(article.toJson()));

    // Keep only max items
    if (historyJson.length > _maxHistoryItems) {
      historyJson.removeRange(_maxHistoryItems, historyJson.length);
    }

    await prefs.setStringList(_historyKey, historyJson);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<bool> isInHistory(NewsArticle article) async {
    final history = await getHistory();
    return history.any((item) => item.url == article.url);
  }
}
