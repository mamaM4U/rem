import 'package:json_annotation/json_annotation.dart';

part 'home_data.g.dart';

@JsonSerializable()
class HomeData {
  final String title;
  final String description;
  final List<HomeItem> items;

  HomeData({
    required this.title,
    required this.description,
    required this.items,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);
  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}

@JsonSerializable()
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

  factory HomeItem.fromJson(Map<String, dynamic> json) =>
      _$HomeItemFromJson(json);
  Map<String, dynamic> toJson() => _$HomeItemToJson(this);
}
