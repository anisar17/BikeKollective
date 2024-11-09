import 'package:flutter/material.dart';

void reportIssue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ReportIssueDialog();
    },
  );
}

class ReportIssueDialog extends StatefulWidget {
  const ReportIssueDialog({Key? key}) : super(key: key);

  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final TextEditingController feedbackController = TextEditingController();
  String selectedIssueType = "Select an Issue";

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            Text(selectedIssueType,
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                hintText: "Type your feedback here...",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              String feedbackText = feedbackController.text;
              print("Feedback for $selectedIssueType: $feedbackText");
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('SUBMIT'),
          ),
        ),
      ],
    );
  }
}
