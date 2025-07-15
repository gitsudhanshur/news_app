class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String author;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    print(json);

    return Article(
      title: json['title'] ?? 'No Title Available',
      description: json['description'] ?? 'No description available',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      author: json['author'] ?? 'No author available',
    );
  }
}
