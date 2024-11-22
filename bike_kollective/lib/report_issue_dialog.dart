import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => reportIssue(context),
          child: Text("Report an Issue"),
        ),
      ),
    );
  }
}
void reportIssue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportIssueDialog(onClose: () {
        Navigator.of(context).pop(); // Closes the dialog
      });
    },
  );
}

class ReportIssueDialog extends StatefulWidget {
  final VoidCallback onClose;

  ReportIssueDialog({Key? key, required this.onClose}) : super(key: key);

  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final TextEditingController feedbackController = TextEditingController();
  String selectedIssueType = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          "Report an Issue",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _issueButton("STOLEN"),
                  _issueButton("NOT IN WORKING CONDITION"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _issueButton("LOCK WON'T WORK"),
                  _issueButton("LOCK MISSING"),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                selectedIssueType.isNotEmpty ? selectedIssueType : "Please select an issue",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  hintText: "Type your feedback here (optional)...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                // Make feedback optional, so remove the validator:
                // You can add a comment to acknowledge an empty feedback
                validator: (value) {
                  if (selectedIssueType.isEmpty) {
                    return "Please select an issue type";
                  }
                  return null; // Allow empty feedback
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String feedbackText = feedbackController.text;
                print("Feedback for $selectedIssueType: $feedbackText");
                widget.onClose(); // Close the dialog after "Submit" is pressed
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("SUBMIT"),
          ),
        ),
      ],
    );
  }

  ElevatedButton _issueButton(String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedIssueType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIssueType == type ? Colors.blue : const Color.fromARGB(255, 239, 242, 243),
        foregroundColor: selectedIssueType == type ? Colors.white : const Color.fromARGB(255, 2, 138, 250),
      ),
      child: Text(type, style: const TextStyle(fontSize: 12)),
    );
  }
}
