import '../models/news_article.dart';
import '../services/api_service.dart';

class NewsRepository {
  final ApiService _apiService;

  NewsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<NewsArticle>> getTrendingNews() async {
    return await _apiService.getTopHeadlines(pageSize: 5);
  }

  Future<List<NewsArticle>> getLatestNews({String category = 'general'}) async {
    return await _apiService.getNewsByCategory(
      category: category,
      pageSize: 20,
    );
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    return await _apiService.searchNews(query: query);
  }
}
