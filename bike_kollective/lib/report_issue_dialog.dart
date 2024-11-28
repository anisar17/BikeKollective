import 'package:bike_kollective/data/model/issue.dart';
import 'package:flutter/material.dart';

void showReportIssueDialog(BuildContext context, Function(IssueTag issue, String comment) onClose) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportIssueDialog(onClose: (IssueTag issue, String comment) {
        onClose(issue, comment);
        Navigator.of(context).pop();  // Close the dialog from the callback
      });
    },
  );
}

class ReportIssueDialog extends StatefulWidget {
  final void Function(IssueTag issue, String comment) onClose;

  ReportIssueDialog({Key? key, required this.onClose}) : super(key: key);

  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final TextEditingController feedbackController = TextEditingController();
  IssueTag? selectedIssueType;
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
                  _issueButton(IssueTag.stolen),
                  _issueButton(IssueTag.broken),
                  _issueButton(IssueTag.lockBroken),
                  _issueButton(IssueTag.lockMissing),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                (selectedIssueType != null) ? "" : "Please select an issue",
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
                validator: (value) {
                  if (selectedIssueType == null) {
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
                widget.onClose(selectedIssueType!, feedbackController.text); // Call the onClose callback to close the dialog
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

  ElevatedButton _issueButton(IssueTag tag) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedIssueType = tag;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIssueType == tag ? Colors.blue : const Color.fromARGB(255, 239, 242, 243),
        foregroundColor: selectedIssueType == tag ? Colors.white : const Color.fromARGB(255, 2, 138, 250),
      ),
      child: Text(tagDisplayNames[tag]!, style: const TextStyle(fontSize: 12)),
    );
  }
}
