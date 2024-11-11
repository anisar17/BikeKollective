import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class CurrentRideMap extends StatefulWidget {
  const CurrentRideMap({super.key});

  @override
  _CurrentRideMapState createState() => _CurrentRideMapState();
}

class _CurrentRideMapState extends State<CurrentRideMap> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(enableTracking: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller: mapController,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
