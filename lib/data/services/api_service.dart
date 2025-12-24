import 'package:dio/dio.dart';
import '../../config/constants.dart';
import '../models/news_article.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'X-Api-Key': ApiConstants.apiKey,
          },
        ));

  Future<List<NewsArticle>> getTopHeadlines({
    String country = 'us',
    String? category,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.topHeadlines,
        queryParameters: {
          'country': country,
          if (category != null && category != 'general') 'category': category,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        final articles = (response.data['articles'] as List)
            .map((article) => NewsArticle.fromJson(article))
            .where((article) => article.urlToImage != null)
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your NewsAPI key.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<NewsArticle>> searchNews({
    required String query,
    String language = 'en',
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.everything,
        queryParameters: {
          'q': query,
          'language': language,
          'pageSize': pageSize,
          'sortBy': 'publishedAt',
        },
      );

      if (response.statusCode == 200) {
        final articles = (response.data['articles'] as List)
            .map((article) => NewsArticle.fromJson(article))
            .where((article) => article.urlToImage != null)
            .toList();
        return articles;
      } else {
        throw Exception('Failed to search news');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<NewsArticle>> getNewsByCategory({
    required String category,
    int pageSize = 20,
  }) async {
    if (category == 'general' || category == 'All') {
      return getTopHeadlines(pageSize: pageSize);
    }
    return getTopHeadlines(category: category, pageSize: pageSize);
  }
}
