import 'package:bike_kollective/data/model/app_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides reported errors
final errorProvider = StreamNotifierProvider<ErrorNotifier, AppErrorModel>(() {
  return ErrorNotifier();
});

class ErrorNotifier extends StreamNotifier<AppErrorModel> {
  ErrorNotifier() : super();
  
  @override
  Stream<AppErrorModel> build() {
    // TODO: implement build, need to be able to queue up errors and broadcast them out
    throw UnimplementedError();
  }
}
