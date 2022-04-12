class HeadlineItem {
  final String? author;
  final String title;
  final String? description;
  final String content;
  final String publishedAt;
  final String? image;
  
  const HeadlineItem({
    this.author,
    required this.title,
    this.description,
    required this.content,
    required this.publishedAt,
    this.image
  });

  factory HeadlineItem.fromJson(Map<String, dynamic> json) {
    return HeadlineItem(
      author: json['author'] ?? null,
      title: json['title'],
      description: json['description'] ?? null,
      content: json['content'] ?? json["url"],
      publishedAt: json['publishedAt'],
      image: json['urlToImage'] ?? null
    );
  }
}
