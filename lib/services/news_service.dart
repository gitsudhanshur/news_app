import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String apiUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=9f4bea97f22447c0bd3bda9e0b5f729c';

  Future<List<Article>> fetchNews(int page) async {
    final response = await http.get(Uri.parse('$apiUrl&page=$page'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> articlesJson = data['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
