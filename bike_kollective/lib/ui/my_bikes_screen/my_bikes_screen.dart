import 'package:bike_kollective/data/provider/owned_bikes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/ui/widgets/bikes_viewer.dart';

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
    var bikes = ref.watch(ownedBikesProvider);
    if (bikes.isEmpty) {
      return const Center(child: Text('No bikes available'));
    }

    return Center(
      child: BikesViewer(availableBikes: bikes, isMyBikes: true),
    );
  }
}
