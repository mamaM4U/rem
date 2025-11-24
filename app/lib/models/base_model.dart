import 'package:json_annotation/json_annotation.dart';

class BaseModel {
  String? id;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  BaseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
  });
}
