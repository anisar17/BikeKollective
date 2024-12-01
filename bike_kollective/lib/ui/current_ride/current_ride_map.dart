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

  _CurrentRideMapState() {
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
        onMapIsReady: (isReady) async {
          if (isReady) {
            var position = await mapController.myLocation();
            if (position != null) {
              mapController.goToLocation(position);
            }
          }
        },
        osmOption: OSMOption(
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
          userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.blue,
                size: 48,
              ),
            ),
            directionArrowMarker: MarkerIcon(
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
