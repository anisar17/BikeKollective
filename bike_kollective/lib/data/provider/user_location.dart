import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides access to the GPS coordinates of the user
// Note: poll location only as needed to save battery life
final userLocationProvider = Provider<UserLocation>((ref) {
  // return DebugUserLocation(); // Uncomment to work with debug data instead of real GPS data
  return RealUserLocation();
});

class Loc {
  final double lat;
  final double lng;

  const Loc({
    required this.lat,
    required this.lng,
  });
}

// Interface for accessing user location data (implementations are below)
abstract class UserLocation {
  Future<Loc> getCurrentLocation();
  Future<Loc> forceCurrentLocation(Loc location);
  // TODO - add any other location methods (e.g. accessing location history, etc)
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DebugData in the databaseProvider above
class DebugUserLocation extends UserLocation {
  // TODO - fill in with useful debug data and handling for modifying it
}

// TODO - define Mocks for automated testing? Perhaps later

// This implementation requests GPS coordinates from the phone or browser
class RealUserLocation extends UserLocation {
  // TODO - fill in with handling for getting user location, including app permissions
  // TODO - consider caching GPS data to save battery?
}
