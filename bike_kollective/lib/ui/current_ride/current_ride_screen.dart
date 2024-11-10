import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/ui/current_ride/current_ride_map.dart';
import 'package:bike_kollective/ui/screens/ride_feedback/ride_feedback_screen.dart';

class CurrentRideScreen extends StatelessWidget {
  // Dummy data for the ride
  final RideModel ride = RideModel(
    docRef: BKDocumentReference.fake("dummy_ride_id"),
    rider: BKDocumentReference.fake("dummy_rider_id"),
    bike: BKDocumentReference.fake("dummy_bike_id"),
    startPoint: const BKGeoPoint(34.4208, -119.6982),
    startTime: DateTime.now().subtract(const Duration(hours: 1)),
    finishPoint: null,
    finishTime: DateTime.now().add(const Duration(hours: 3, minutes: 25)),
    review: null,
  );

  // Dummy data for the bike
  final BikeModel bike = BikeModel(
    docRef: BKDocumentReference.fake("dummy_bike_id"),
    owner: BKDocumentReference.fake("fakeUserId"),
    name: "Trek Road Bike",
    type: BikeType.road,
    description: "Good road bike for cruising around town.",
    code: "1234",
    imageUrl:
        "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(34.4208, -119.6982),
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  );

  Duration getRemainingTime() {
    final now = DateTime.now();
    return ride.finishTime != null
        ? ride.finishTime!.difference(now)
        : Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = getRemainingTime();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left-aligned Bike name
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              bike.name,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          // Bike Image
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(bike.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Expanded Map Component to take all remaining vertical space
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200], // Background color for map container
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CurrentRideMap(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lock Combination: ${bike.code}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Remaining Time: ${remainingTime.inHours} Hours ${remainingTime.inMinutes.remainder(60)} Min",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement report issue functionality here
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                  child: const Text("Report an Issue"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement finish ride functionality here
                    // Navigate to the RideFeedbackScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideFeedbackScreen(
                            ride: ride), // Pass the ride instance
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text("Finish Ride"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
