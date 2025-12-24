import 'package:equatable/equatable.dart';
import '../../../data/models/news_article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> trendingNews;
  final List<NewsArticle> latestNews;
  final String selectedCategory;

  const NewsLoaded({
    required this.trendingNews,
    required this.latestNews,
    this.selectedCategory = 'All',
  });

  @override
  List<Object?> get props => [trendingNews, latestNews, selectedCategory];

  NewsLoaded copyWith({
    List<NewsArticle>? trendingNews,
    List<NewsArticle>? latestNews,
    String? selectedCategory,
  }) {
    return NewsLoaded(
      trendingNews: trendingNews ?? this.trendingNews,
      latestNews: latestNews ?? this.latestNews,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
