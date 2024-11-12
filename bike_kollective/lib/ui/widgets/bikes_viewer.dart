import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/ui/widgets/bikes_list_view.dart';
import 'package:bike_kollective/ui/widgets/bikes_map_view.dart';

class BikesViewer extends StatefulWidget {
  final List<BikeModel> availableBikes;
  final bool isMyBikes;

  const BikesViewer(
      {super.key, required this.availableBikes, required this.isMyBikes});

  @override
  _BikesViewerState createState() => _BikesViewerState();
}

class _BikesViewerState extends State<BikesViewer> {
  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    widget.availableBikes.forEach((bike) {
      print("BikesViewer Bike: ${bike.name}, Distance: ${bike.distance}");
    });
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isListView
                ? BikesListView(
                    availableBikes: widget.availableBikes,
                    isMyBikes: widget.isMyBikes)
                : BikesMapView(
                    availableBikes: widget.availableBikes,
                    isMyBikes: widget.isMyBikes),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isListView = true;
                    });
                  },
                  child: Text(
                    'List View',
                    style: TextStyle(
                      color: isListView ? Colors.black : Colors.grey,
                      fontSize: 16,
                      fontWeight:
                          isListView ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isListView = false;
                    });
                  },
                  child: Text(
                    'Map View',
                    style: TextStyle(
                      color: isListView ? Colors.grey : Colors.black,
                      fontSize: 16,
                      fontWeight:
                          isListView ? FontWeight.w500 : FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
