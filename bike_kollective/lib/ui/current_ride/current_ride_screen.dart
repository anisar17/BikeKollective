import 'package:bike_kollective/data/provider/available_bikes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/provider/active_ride.dart';
import 'package:bike_kollective/ui/current_ride/current_ride_map.dart';
import 'package:bike_kollective/ui/screens/ride_feedback/ride_feedback_screen.dart';
import 'package:bike_kollective/report_issue_dialog.dart';

class CurrentRideScreen extends ConsumerStatefulWidget {
  @override
  _CurrentRideScreenState createState() => _CurrentRideScreenState();
}

class _CurrentRideScreenState extends ConsumerState<CurrentRideScreen> {
  bool isDialogOpen = false; // Track if the dialog is open

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(activeRideProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    var activeRide = ref.watch(activeRideProvider);
    if(activeRide == null) {
      return const Center(child: Text('No ride in progress'));
    }
    else if (isDialogOpen) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Report an Issue'),
        ),
        body: Center(
          child: ReportIssueDialog(
            onClose: (IssueTag issue, String comment) async {
              await ref.read(activeRideProvider.notifier).reportIssue(IssueModel.newIssue(
                reporter: activeRide.rider,
                bike: activeRide.bike,
                tags: [issue],
                comment: comment,
              ));
              setState(() {
                isDialogOpen = false; // Close dialog and return to main screen
              });
              // Leave this bike and go back to the list of available bikes
              await ref.read(availableBikesProvider.notifier).refresh();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ),
      );
    } else {
      // Get the bike being ridden
      var bike = ref.read(activeRideProvider.notifier).getBike()!;
      // Get the remaining time, if any
      final remainingTime = activeRide.getRemaining();
    
      // Default layout with the map and bike details when dialog is not open
      return Scaffold(
        body: GestureDetector(
          onTap: () {
            if (isDialogOpen) {
              // Close the keyboard if the dialog is open and tapped outside
              FocusScope.of(context).unfocus();
            }
          },
          child: ListView(
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
                height: 200,
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
              // Check for over time and conditionally display a warning message
              if (remainingTime.isNegative || remainingTime.inHours == 0 && remainingTime.inMinutes <= 0)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.redAccent, // Background color for the warning
                  child: const Text(
                    "⚠️ Your time is out! Please finish ride and lock bike.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(
                height: 200,
                child: Expanded(
                  child: CurrentRideMap(enabled: !isDialogOpen), // Conditional rendering based on dialog state
                )
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
                      "Remaining Time: ${remainingTime.inHours} Hours, ${remainingTime.inMinutes.remainder(60)} Minutes",
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
                        setState(() {
                          isDialogOpen = true; // Set the dialog open state to true
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text("Report Issue"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RideFeedbackScreen(
                              ride: activeRide,
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
}