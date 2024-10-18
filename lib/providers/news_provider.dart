import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  NewsNotifier() : super(const AsyncValue.loading()) {
    fetchNews();
  }

  final NewsService _newsService = NewsService();
  int _page = 1;
  bool _isLoadingMore = false;

  Future<void> fetchNews() async {
    try {
      state = const AsyncValue.loading();
      
      final articles = await _newsService.fetchNews(_page);
      
      state = AsyncValue.data(articles);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMoreNews() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    _page++;
    
    try {
      final newArticles = await _newsService.fetchNews(_page);
      
      state = state.whenData((articles) => [...articles, ...newArticles]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } finally {
      _isLoadingMore = false;
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, AsyncValue<List<Article>>>((ref) {
  return NewsNotifier();
});
