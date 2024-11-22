import 'dart:math';
import 'package:bike_kollective/data/model/bk_geo_point.dart';

double calculateDistance(BKGeoPoint userLocation, BKGeoPoint bikeLocation) {
  const double earthRadiusKm = 6371;
  const double kmToMiles = 0.621371;

  final double dLat = _toRadians(bikeLocation.latitude - userLocation.latitude);
  final double dLng =
      _toRadians(bikeLocation.longitude - userLocation.longitude);

  final double a = (sin(dLat / 2) * sin(dLat / 2)) +
      cos(_toRadians(userLocation.latitude)) *
          cos(_toRadians(bikeLocation.latitude)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final double distanceInMiles = (earthRadiusKm * c * kmToMiles);
  return double.parse(distanceInMiles.toStringAsFixed(2));
}

double _toRadians(double degree) => degree * (pi / 180);
