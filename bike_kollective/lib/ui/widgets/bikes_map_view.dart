import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';

class BikesMapView extends StatelessWidget {
  final List<BikeModel> availableBikes;

  const BikesMapView({super.key, required this.availableBikes});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("Bikes Map View"));
  }
}
