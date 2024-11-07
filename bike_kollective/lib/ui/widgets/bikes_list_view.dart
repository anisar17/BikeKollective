import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/bike_details_screen.dart';

class BikesListView extends StatelessWidget {
  final List<BikeModel> availableBikes;

  const BikesListView({super.key, required this.availableBikes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: availableBikes.length,
              itemBuilder: (context, index) {
                final bike = availableBikes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: MouseRegion(
                    cursor:
                        SystemMouseCursors.click, // Change cursor to pointer
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to BikeDetailsScreen, passing the selected bike
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BikeDetailsScreen(bike: bike),
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
                          trailing: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, color: Colors.blue),
                              SizedBox(height: 4),
                              Text(
                                'XX Miles',
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
