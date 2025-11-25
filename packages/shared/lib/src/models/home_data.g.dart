// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      title: json['title'] as String,
      description: json['description'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => HomeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'items': instance.items,
    };

HomeItem _$HomeItemFromJson(Map<String, dynamic> json) => HomeItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$HomeItemToJson(HomeItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
    };
