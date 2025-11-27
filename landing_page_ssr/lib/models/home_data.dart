class HomeData {
  final String title;
  final String description;
  final List<HomeItem> items;

  HomeData({
    required this.title,
    required this.description,
    required this.items,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      title: json['title'] as String,
      description: json['description'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => HomeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HomeItem {
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;

  HomeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });

  factory HomeItem.fromJson(Map<String, dynamic> json) {
    return HomeItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
