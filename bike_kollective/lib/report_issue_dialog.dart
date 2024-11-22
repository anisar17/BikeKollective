import 'package:flutter/material.dart';

void reportIssue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportIssueDialog(onClose: () {
        Navigator.of(context).pop(); // This will close the dialog
      });
    },
  );
}

class ReportIssueDialog extends StatefulWidget {
  final VoidCallback onClose; // Add the onClose callback

  ReportIssueDialog({Key? key, required this.onClose}) : super(key: key);

  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final TextEditingController feedbackController = TextEditingController();
  String selectedIssueType = "Select an Issue";
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
          'Report an Issue',
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
              // Your buttons and other UI elements...
              // Existing button code...
              TextFormField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  hintText: "Type your feedback here...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
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
                widget.onClose(); // Invoke the onClose callback
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('SUBMIT'),
          ),
        ),
      ],
    );
  }
}
