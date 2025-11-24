import 'dart:async';
import 'package:flutter/foundation.dart';

class Debounce {
  final int milliseconds;
  Timer? _timer;

  Debounce({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }
}
