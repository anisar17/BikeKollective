import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides access to the GPS coordinates of the user
// Note: poll location only as needed to save battery life
final userLocationProvider = Provider<UserLocation>((ref) {
  return DummyUserLocation(); // Uncomment to work with dummy data instead of real GPS data
  return RealUserLocation();
});

// Interface for accessing user location data (implementations are below)
abstract class UserLocation {
  Future<BKGeoPoint> forceCurrent(BKGeoPoint point);
  Future<BKGeoPoint> getCurrent();
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DummyUserLocation in the databaseProvider above
class DummyUserLocation extends UserLocation {
  BKGeoPoint _point;

  DummyUserLocation() : _point = const BKGeoPoint(44.561, -123.260);

  @override
  Future<BKGeoPoint> forceCurrent(BKGeoPoint point) {
    return Future<BKGeoPoint>.sync(() {
      _point = point;
      return _point;
    });
  }

  @override
  Future<BKGeoPoint> getCurrent() {
    return Future<BKGeoPoint>.sync(() {
      return _point;
    });
  }
}

// This implementation requests GPS coordinates from the phone or browser
// TODO - fill in with handling for getting user location, including app permissions
// TODO - consider caching GPS data to save battery?
class RealUserLocation extends UserLocation {
  @override
  Future<BKGeoPoint> forceCurrent(BKGeoPoint point) {
    // TODO: implement forceCurrent
    throw UnimplementedError();
  }

  @override
  Future<BKGeoPoint> getCurrent() {
    // TODO: implement getCurrent
    throw UnimplementedError();
  }
}

// TODO - define Mocks for automated testing? Perhaps later
