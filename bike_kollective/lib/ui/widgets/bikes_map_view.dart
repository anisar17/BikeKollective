import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/ui/widgets/osm_map.dart';

class BikesMapView extends StatelessWidget {
  final List<BikeModel> availableBikes;

  const BikesMapView({Key? key, required this.availableBikes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMMapWithMarkers(bikes: availableBikes),
    );
  }
}
