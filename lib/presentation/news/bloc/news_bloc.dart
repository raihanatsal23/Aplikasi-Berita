import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _repository;

  NewsBloc({NewsRepository? repository})
      : _repository = repository ?? NewsRepository(),
        super(NewsInitial()) {
    on<LoadTrendingNews>(_onLoadTrendingNews);
    on<LoadLatestNews>(_onLoadLatestNews);
    on<SearchNews>(_onSearchNews);
    on<RefreshNews>(_onRefreshNews);
  }

  Future<void> _onLoadTrendingNews(
    LoadTrendingNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      emit(NewsLoading());

      final trending = await _repository.getTrendingNews();
      final latest = await _repository.getLatestNews();

      emit(NewsLoaded(
        trendingNews: trending,
        latestNews: latest,
      ));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onLoadLatestNews(
    LoadLatestNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;

        final latest = await _repository.getLatestNews(
          category: event.category,
        );

        emit(currentState.copyWith(
          latestNews: latest,
          selectedCategory: event.category,
        ));
      }
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onSearchNews(
    SearchNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;

        if (event.query.isEmpty) {
          final latest = await _repository.getLatestNews();
          emit(currentState.copyWith(latestNews: latest));
        } else {
          final searchResults = await _repository.searchNews(event.query);
          emit(currentState.copyWith(latestNews: searchResults));
        }
      }
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      final trending = await _repository.getTrendingNews();
      final latest = await _repository.getLatestNews();

      emit(NewsLoaded(
        trendingNews: trending,
        latestNews: latest,
      ));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
