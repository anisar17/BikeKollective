import 'dart:async';
import 'package:bike_kollective/data/model/app_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides reported app errors
final errorProvider = StreamNotifierProvider<ErrorNotifier, AppError>(() {
  return ErrorNotifier();
});

class ErrorNotifier extends StreamNotifier<AppError> {
  final StreamController<AppError> _controller = StreamController<AppError>();
  
  @override
  Stream<AppError> build() {
    return _controller.stream;
  }

  void report(AppError error) {
    _controller.add(error);
  }
}
