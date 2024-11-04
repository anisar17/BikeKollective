import 'package:bike_kollective/bike_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:bike_kollective/data/model/bike.dart';

class OSMMapWithMarkers extends StatefulWidget {
  final List<BikeModel> bikes;

  const OSMMapWithMarkers({super.key, required this.bikes});

  @override
  _OSMMapWithMarkersState createState() => _OSMMapWithMarkersState();
}

class _OSMMapWithMarkersState extends State<OSMMapWithMarkers> {
  late MapController mapController;
  String? hoveredBikeName;
  Offset? hoveredPosition;

  @override
  void initState() {
    super.initState();
    mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(enableTracking: true),
    );
  }

  void navigateToBikeDetails(BikeModel bike) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BikeDetailsScreen(bike: bike),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller: mapController,
        onMapIsReady: (isReady) async {
          if (isReady) {
            await addMarkers();
          }
        },
        onGeoPointClicked: (GeoPoint point) {
          try {
            BikeModel selectedBike = widget.bikes.firstWhere(
              (bike) =>
                  bike.locationPoint.latitude == point.latitude &&
                  bike.locationPoint.longitude == point.longitude,
            );
            navigateToBikeDetails(selectedBike);
          } catch (e) {
            print('Bike not found');
          }
        },
        osmOption: OSMOption(
          userTrackingOption: const UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: const ZoomOption(
            initZoom: 14,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.blue,
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: const RoadOption(
            roadColor: Colors.yellowAccent,
          ),
        ),
      ),
    );
  }

  Future<void> addMarkers() async {
    // Add a marker for each bike at its specified location
    for (var bike in widget.bikes) {
      await mapController.addMarker(
        GeoPoint(
          latitude: bike.locationPoint.latitude,
          longitude: bike.locationPoint.longitude,
        ),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 48,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
