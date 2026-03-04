import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

/// Base response wrapper untuk semua API responses
@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;

  BaseResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);

  /// Success response
  factory BaseResponse.success({
    T? data,
    String? message,
  }) {
    return BaseResponse(
      success: true,
      data: data,
      message: message ?? 'Success',
    );
  }

  /// Error response
  factory BaseResponse.error({
    required String message,
    Map<String, dynamic>? errors,
  }) {
    return BaseResponse(
      success: false,
      message: message,
      errors: errors,
    );
  }
}
