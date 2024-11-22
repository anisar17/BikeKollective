import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class CurrentRideMap extends StatefulWidget {
  final bool enabled;

  const CurrentRideMap({Key? key, this.enabled = true}) : super(key: key);

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
    return IgnorePointer(
      ignoring: !widget.enabled, // This will manage user interaction
      child: OSMFlutter(
        controller: mapController,
        osmOption: const OSMOption(
          userTrackingOption: UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: ZoomOption(
            initZoom: 14,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
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
