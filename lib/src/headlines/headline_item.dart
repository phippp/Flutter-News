/// A placeholder class that represents an entity or model.
class HeadlineItem {
  final String? author;
  final String title;
  final String? description;
  final String? content;
  final String? publishedAt;
  
  const HeadlineItem({
    this.author,
    required this.title,
    this.description,
    this.content,
    this.publishedAt
  });

  factory HeadlineItem.fromJson(Map<String, dynamic> json) {
    return HeadlineItem(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      publishedAt: json['publishedAt'],
    );
  }
}