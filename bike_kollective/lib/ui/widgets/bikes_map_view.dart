import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/ui/widgets/osm_map.dart';
import 'package:bike_kollective/data/model/bike_with_distance.dart';

class BikesMapView extends StatelessWidget {
  final List<BikeWithDistanceModel> availableBikes;
  final bool isMyBikes;

  const BikesMapView(
      {Key? key, required this.availableBikes, required this.isMyBikes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMMapWithMarkers(bikes: availableBikes, isMyBikes: isMyBikes),
    );
  }
}
