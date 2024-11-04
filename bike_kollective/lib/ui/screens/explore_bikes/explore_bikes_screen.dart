import 'package:bike_kollective/data/provider/available_bikes.dart';
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
    var bikes = ref.watch(availableBikesProvider);
    if (bikes.isEmpty) {
      return const Center(child: Text('No bikes available'));
    }

    return Center(
      child: BikesViewer(availableBikes: bikes),
    );
  }
}
