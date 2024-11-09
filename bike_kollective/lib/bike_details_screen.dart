import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'bike_details_view.dart'; // Import the new BikeDetailsView component

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

class ReportIssueDialog extends StatefulWidget {
  const ReportIssueDialog({super.key});

  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final TextEditingController feedbackController = TextEditingController();
  String selectedIssueType = "Select an Issue"; // Default text

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Report an Issue',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for limiting size
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Spread buttons evenly
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIssueType = "STOLEN";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 242, 243),
                    foregroundColor: const Color.fromARGB(255, 2, 138, 250),
                  ),
                  child: Text('STOLEN', style: TextStyle(fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIssueType = "NOT IN WORKING CONDITION";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 242, 243),
                    foregroundColor: const Color.fromARGB(255, 2, 138, 250),
                  ),
                  child: Text('NOT IN WORKING CONDITION',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIssueType = "LOCK WONT WORK";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 242, 243),
                    foregroundColor: const Color.fromARGB(255, 2, 138, 250),
                  ),
                  child: Text('LOCK WONT WORK', style: TextStyle(fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIssueType = "LOCK MISSING";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 242, 243),
                    foregroundColor: const Color.fromARGB(255, 2, 138, 250),
                  ),
                  child: Text('LOCK MISSING', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            SizedBox(
                height: 20), // Add some padding between buttons and TextField
            Text(selectedIssueType,
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                hintText: "Type your feedback here...",
                hintStyle: TextStyle(color: Colors.grey), // Gray color for hint
                border: OutlineInputBorder(), // Add border to TextField
              ),
              maxLines: 5, // Allow space for multiple lines in the TextField
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Handle the submission of the feedback here
              String feedbackText = feedbackController.text;
              print(
                  "Feedback for $selectedIssueType: $feedbackText"); // For debugging
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, //set the background color to blue
              foregroundColor: Colors.white, //set the text color to white
            ),
            child: Text('SUBMIT'),
          ),
        ),
      ],
    );
  }
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
