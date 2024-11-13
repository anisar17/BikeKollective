import 'dart:io';

import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Provides access to the GPS coordinates of the user
// Note: poll location only as needed to save battery life
final userLocationProvider = Provider<UserLocation>((ref) {
  //return DummyUserLocation(); // Uncomment to work with dummy data instead of real GPS data
  return RealUserLocation();
});

// Interface for accessing user location data (implementations are below)
abstract class UserLocation {
  Future<BKGeoPoint> getCurrent();
}

class LocationException implements Exception {
  String message;
  LocationException(this.message);
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DummyUserLocation in the databaseProvider above
class DummyUserLocation extends UserLocation {
  BKGeoPoint _point;

  DummyUserLocation() : _point = const BKGeoPoint(44.564, -123.2618);

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
  Future<BKGeoPoint> getCurrent() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw LocationException("Failed to request service");
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw LocationException("Failed to request permission");
      }
    }

    LocationData currentPosition = await location.getLocation();
    return BKGeoPoint(currentPosition.latitude!, currentPosition.longitude!);
  }
}
