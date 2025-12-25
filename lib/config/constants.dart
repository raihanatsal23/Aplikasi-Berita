class ApiConstants {
  // NewsAPI.org Configuration
  static const String baseUrl = 'https://newsapi.org/v2';

  // ⚠️ GANTI DENGAN API KEY KAMU!
  static const String apiKey = 'Gunakan API Key Masing Masing';

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // Default params
  static const String defaultCountry = 'us';
  static const String defaultLanguage = 'en';
}

class AppConstants {
  static const String appName = 'YB News';

  // Categories
  static const List<String> categories = [
    'All',
    'Sports',
    'Politics',
    'Business',
    'Health',
    'Travel',
    'Science',
  ];

  // Category mapping to NewsAPI categories
  static const Map<String, String> categoryMapping = {
    'All': 'general',
    'Sports': 'sports',
    'Politics': 'politics',
    'Business': 'business',
    'Health': 'health',
    'Travel': 'general',
    'Science': 'science',
  };
}
