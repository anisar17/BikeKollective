import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'bike_details_view.dart';
import 'report_issue_dialog.dart';

// Define the BikeDetailsScreen widget
class BikeDetailsScreen extends ConsumerWidget {
  final BikeModel bike;

  const BikeDetailsScreen({super.key, required this.bike});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bike.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BikeDetailsView(
                bike: bike), // Include the BikeDetailsView component
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    reportIssue(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Report issue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkOutBike(context, bike);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Check out bike',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Show a pop-out dialog to report an issue
void reportIssue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportIssueDialog();
    },
  );
}

// Show a pop-out with lock code
void checkOutBike(BuildContext context, BikeModel bike) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
            child: Text(
          'Enjoy your ride!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        )), // Center the title
        content: SingleChildScrollView(
          // Allow content to scroll
          child: Column(
            children: [
              Text(
                'The lock combination is:',
                textAlign: TextAlign.center, // Center align text
              ),
              Text(
                ' ${bike.code}',
                textAlign: TextAlign.center, // Center align text
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                'You have 8 hours to return the bike',
                textAlign: TextAlign.center, // Center align text
              ),
            ],
          ),
        ),
        actions: [
          Center(
            // Center the buttons
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-out dialog box
              },
              child: Text('OK'),
            ),
          ),
        ],
      );
    },
  );
}
