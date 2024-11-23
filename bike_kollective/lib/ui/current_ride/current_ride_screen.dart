import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/ui/current_ride/current_ride_map.dart';
import 'package:bike_kollective/ui/screens/ride_feedback/ride_feedback_screen.dart';
import 'package:bike_kollective/report_issue_dialog.dart';

class CurrentRideScreen extends StatefulWidget {
  @override
  _CurrentRideScreenState createState() => _CurrentRideScreenState();
}

class _CurrentRideScreenState extends State<CurrentRideScreen> {
  bool isDialogOpen = false; // Track if the dialog is open

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
    totalStars: 5,
    totalReviews: 1,
  );

  Duration getRemainingTime() {
    final now = DateTime.now();
    return ride.finishTime != null
        ? ride.finishTime!.difference(now)
        : Duration.zero;
  }

  void reportIssue(BuildContext context) {
    setState(() {
      isDialogOpen = true; // Set the dialog open state to true
    });

    // Use the reportIssue method from the updated dialog
    showDialog(
      context: context,
      builder: (context) {
        return ReportIssueDialog(
          onClose: () {
            setState(() {
              isDialogOpen = false; // Close the dialog and update state
            });
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = getRemainingTime();

    // If the dialog is open, replace the map with the dialog
    if (isDialogOpen) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Report an Issue'),
        ),
        body: Center(
          child: ReportIssueDialog(
            onClose: () {
              setState(() {
                isDialogOpen = false; // Close dialog and return to main screen
              });
            },
          ),
        ),
      );
    }
    
    // Default layout with the map and bike details when dialog is not open
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (isDialogOpen) {
            // Close the keyboard if the dialog is open and tapped outside
            FocusScope.of(context).unfocus();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                bike.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
            Expanded(
              child: CurrentRideMap(enabled: !isDialogOpen), // Conditional rendering based on dialog state
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      reportIssue(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text("Report an Issue"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RideFeedbackScreen(
                            ride: ride,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text("Finish Ride"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
