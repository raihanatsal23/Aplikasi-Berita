import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrendingNews extends NewsEvent {}

class LoadLatestNews extends NewsEvent {
  final String category;

  const LoadLatestNews({this.category = 'general'});

  @override
  List<Object?> get props => [category];
}

class SearchNews extends NewsEvent {
  final String query;

  const SearchNews(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshNews extends NewsEvent {}
