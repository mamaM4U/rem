import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

devPrint(Object? obj, {String? title, bool encodeJSON = false}) {
  if (kDebugMode) {
    const encoder = JsonEncoder.withIndent("  ");
    String body = encodeJSON ? encoder.convert(obj) : '$obj';
    String message = "${title != null ? '$title: \n' : ''} $body";
    developer.log(message);
  }
}
