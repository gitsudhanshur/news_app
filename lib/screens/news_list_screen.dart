import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import 'article_detail_screen.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(newsProvider.notifier).fetchNews();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(newsProvider.notifier).loadMoreNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final articlesState = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('News App', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: articlesState.when(
        data: (articles) => ListView.builder(
          controller: _scrollController,
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return ListTile(
              leading: article.urlToImage != ''
                  ? Image.network(article.urlToImage, width: 100, fit: BoxFit.cover)
                  : SizedBox(width: 100),
              title: Text(article.title, style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(article.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                );
              },
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Failed to load news: $error')),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
