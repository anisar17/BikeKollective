import 'package:cloud_firestore/cloud_firestore.dart';

// Location data
// Note: only the database implementation for Firestore should use
// GeoPoint directly, everyone else should use this type.
class BKGeoPoint {
  final double latitude;
  final double longitude;

  const BKGeoPoint(this.latitude, this.longitude)
      : assert(latitude >= -90 && latitude <= 90),
        assert(longitude >= -180 && longitude <= 180);

  factory BKGeoPoint.fromGeoPoint(GeoPoint point) {
    // Note: should only be called by database implementation for Firestore
    return BKGeoPoint(point.latitude, point.longitude);
  }

  GeoPoint toGeoPoint() {
    // Note: should only be called by database implementation for Firestore
    return GeoPoint(latitude, longitude);
  }
}
