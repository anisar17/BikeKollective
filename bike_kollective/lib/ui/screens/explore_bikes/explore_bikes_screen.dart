import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/ui/widgets/bikes_viewer.dart';
import 'package:bike_kollective/dummy_data/bike_dummy_data.dart';

class ExploreBikesScreen extends ConsumerWidget {
  const ExploreBikesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (availableBikes.isEmpty) {
      return const Center(child: Text('No bikes available'));
    }

    return Center(
      child: BikesViewer(availableBikes: availableBikes),
    );
  }
}
