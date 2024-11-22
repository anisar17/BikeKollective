import 'package:bike_kollective/data/provider/available_bikes.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/ui/widgets/bikes_viewer.dart';

class ExploreBikesScreen extends ConsumerStatefulWidget {
  const ExploreBikesScreen({super.key});

  @override
  ExploreBikesScreenState createState() => ExploreBikesScreenState();
}

class ExploreBikesScreenState extends ConsumerState<ExploreBikesScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(availableBikesProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final bikes = ref.watch(availableBikesProvider);

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

        return Center(
          child: BikesViewer(
            userLocation: snapshot.data!,
            availableBikes: bikes,
            isMyBikes: false,
          ),
        );
      },
    );
  }
}
