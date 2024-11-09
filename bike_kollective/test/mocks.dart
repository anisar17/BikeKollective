import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';

class MockBKDB extends Mock implements BKDB {}
class MockUserLocation extends Mock implements UserLocation {}
class MockActiveUserNotifier extends StateNotifier<UserModel?> with Mock implements ActiveUserNotifier {
  MockActiveUserNotifier(super.state);
}
