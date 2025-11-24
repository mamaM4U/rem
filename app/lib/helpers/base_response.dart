import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true, fieldRename: FieldRename.snake)
class BaseResponse<T> {
  bool success;
  String? message;
  T? data;

  BaseResponse({this.success = false, this.message, this.data});
}
