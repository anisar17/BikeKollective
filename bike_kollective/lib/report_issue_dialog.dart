import 'package:flutter/material.dart';

// TODO: Fix map control taking precedence over report_issue_dialog box

void reportIssue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportIssueDialog();
    },
  );
}

class ReportIssueDialog extends StatefulWidget {
  ReportIssueDialog({Key? key}) : super(key: key);

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
                      backgroundColor: selectedIssueType == "STOLEN"
                          ? Colors.blue
                          : const Color.fromARGB(255, 239, 242, 243),
                      foregroundColor: selectedIssueType == "STOLEN"
                          ? Colors.white
                          : const Color.fromARGB(255, 2, 138, 250),
                    ),
                    child: const Text('STOLEN', style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIssueType = "NOT IN WORKING CONDITION";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIssueType == "NOT IN WORKING CONDITION"
                          ? Colors.blue
                          : const Color.fromARGB(255, 239, 242, 243),
                      foregroundColor: selectedIssueType == "NOT IN WORKING CONDITION"
                          ? Colors.white
                          : const Color.fromARGB(255, 2, 138, 250),
                    ),
                    child: const Text('NOT IN WORKING CONDITION',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIssueType = "LOCK WON'T WORK";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIssueType == "LOCK WON'T WORK"
                          ? Colors.blue
                          : const Color.fromARGB(255, 239, 242, 243),
                      foregroundColor: selectedIssueType == "LOCK WON'T WORK"
                          ? Colors.white
                          : const Color.fromARGB(255, 2, 138, 250),
                    ),
                    child: const Text('LOCK WON\'T WORK', style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIssueType = "LOCK MISSING";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIssueType == "LOCK MISSING"
                          ? Colors.blue
                          : const Color.fromARGB(255, 239, 242, 243),
                      foregroundColor: selectedIssueType == "LOCK MISSING"
                          ? Colors.white
                          : const Color.fromARGB(255, 2, 138, 250),
                    ),
                    child: const Text('LOCK MISSING', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                selectedIssueType,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
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
                Navigator.of(context).pop();
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