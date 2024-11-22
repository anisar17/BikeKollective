import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/distance_calculator.dart';
import 'package:bike_kollective/my_bike_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/bike_details_screen.dart';

class BikesListView extends StatefulWidget {
  final BKGeoPoint userLocation;
  final List<BikeModel> availableBikes;
  final bool isMyBikes;

  const BikesListView({
    super.key,
    required this.userLocation,
    required this.availableBikes,
    required this.isMyBikes});

  @override
  _BikesListViewState createState() => _BikesListViewState();
}

class _BikesListViewState extends State<BikesListView> {
  String searchQuery = '';
  BikeType? selectedType;

  @override
  Widget build(BuildContext context) {
    final lowerCaseQuery = searchQuery.toLowerCase();
    final filteredBikes = widget.availableBikes.where((bike) {
      final matchesSearch = bike.name.toLowerCase().contains(lowerCaseQuery) ||
          bike.description.toLowerCase().contains(lowerCaseQuery) ||
          bike.type.toString().toLowerCase().contains(lowerCaseQuery);
      final matchesType = selectedType == null || bike.type == selectedType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Search and filter row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<BikeType>(
                    value: selectedType,
                    hint: Text(
                      'Filter',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    underline: SizedBox(), // Removes default underline
                    icon: Icon(Icons.filter_list, color: Colors.grey),
                    isExpanded: false,
                    style: TextStyle(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: Colors.white,
                    items: [
                      DropdownMenuItem(value: null, child: Text('All Types')),
                      ...BikeType.values.map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBikes.length,
              itemBuilder: (context, index) {
                final bike = filteredBikes[index];
                final distance = calculateDistance(widget.userLocation, bike.locationPoint);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.isMyBikes
                                ? MyBikeDetailsScreen(bike: bike)
                                : BikeDetailsScreen(bike: bike),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              bike.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            bike.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("123 Main Street"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, color: Colors.blue),
                              SizedBox(height: 4),
                              Text(
                                '${distance} Miles',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
