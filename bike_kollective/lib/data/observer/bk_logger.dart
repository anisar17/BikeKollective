import 'dart:developer';
import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BKLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Log all reported app errors that include a log message
    if(provider == errorProvider) {
      var error = (newValue as AppError);
      if(error.shouldLog()) {
        log(error.logMessage!, time: error.timestamp!, name: error.category.name);
      }
    }
  }
}