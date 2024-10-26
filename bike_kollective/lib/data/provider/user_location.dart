import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides access to the GPS coordinates of the user
// Note: poll location only as needed to save battery life
final userLocationProvider = Provider<UserLocation>((ref) {
  // return DebugUserLocation(); // Uncomment to work with debug data instead of real GPS data
  return RealUserLocation();
});

// Interface for accessing user location data (implementations are below)
abstract class UserLocation {
  Future<GeoPoint> forceCurrent(GeoPoint point);
  Future<GeoPoint> getCurrent();
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DebugData in the databaseProvider above
// TODO - fill in with useful debug data and handling for modifying it
class DebugUserLocation extends UserLocation {
  @override
  Future<GeoPoint> forceCurrent(GeoPoint point) {
    // TODO: implement forceCurrent
    throw UnimplementedError();
  }

  @override
  Future<GeoPoint> getCurrent() {
    // TODO: implement getCurrent
    throw UnimplementedError();
  }
}

// This implementation requests GPS coordinates from the phone or browser
// TODO - fill in with handling for getting user location, including app permissions
// TODO - consider caching GPS data to save battery?
class RealUserLocation extends UserLocation {
  @override
  Future<GeoPoint> forceCurrent(GeoPoint point) {
    // TODO: implement forceCurrent
    throw UnimplementedError();
  }

  @override
  Future<GeoPoint> getCurrent() {
    // TODO: implement getCurrent
    throw UnimplementedError();
  }
}

// TODO - define Mocks for automated testing? Perhaps later
