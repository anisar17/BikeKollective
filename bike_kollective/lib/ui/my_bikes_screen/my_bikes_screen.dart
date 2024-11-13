import 'dart:math';
import 'package:bike_kollective/data/provider/owned_bikes.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/ui/widgets/bikes_viewer.dart';
import 'package:bike_kollective/data/model/bike_with_distance.dart';
import 'package:bike_kollective/distance_calculator.dart';

class MyBikesScreen extends ConsumerStatefulWidget {
  const MyBikesScreen({super.key});

  @override
  MyBikesScreenState createState() => MyBikesScreenState();
}

class MyBikesScreenState extends ConsumerState<MyBikesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ownedBikesProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bikes = ref.watch(ownedBikesProvider);

    if (bikes.isEmpty) {
      return const Center(child: Text('No bikes available'));
    }

    return FutureBuilder<BKGeoPoint>(
      future: ref.read(userLocationProvider).getCurrent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error retrieving location'));
        }

        final userLocation = snapshot.data!;

        // Convert bikes to BikeWithDistanceModel and calculate distances
        final bikesWithDistances = bikes.map((bike) {
          final distance = calculateDistance(userLocation, bike.locationPoint);
          return BikeWithDistanceModel(
            docRef: bike.docRef,
            owner: bike.owner,
            name: bike.name,
            type: bike.type,
            description: bike.description,
            code: bike.code,
            imageUrl: bike.imageUrl,
            status: bike.status,
            locationPoint: bike.locationPoint,
            locationUpdated: bike.locationUpdated,
            rides: bike.rides,
            issues: bike.issues,
            distance: distance,
          );
        }).toList()
          ..sort((a, b) => a.distance.compareTo(b.distance));

        return Center(
          child: BikesViewer(
            availableBikes: bikesWithDistances,
            isMyBikes: true,
          ),
        );
      },
    );
  }
}
