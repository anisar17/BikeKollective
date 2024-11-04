import 'package:mocktail/mocktail.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';

class MockBKDB extends Mock implements BKDB {}
class MockUserLocation extends Mock implements UserLocation {}
