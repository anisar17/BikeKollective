import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:intl/intl.dart';

class BikeIssueView extends StatelessWidget {
  final BikeModel bike;
  final IssueModel? issue;

  const BikeIssueView({Key? key, required this.bike, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(bike.status != BikeStatus.hasIssue) {
      return Text("No issues");
    } else if(issue == null) {
      return Text("Loading issue...");
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            "Please Fix Issue: ${tagDisplayNames[issue!.tags[0]]!}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(issue!.comment),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, color: Colors.blue),
              SizedBox(height: 4),
              Text(
                DateFormat("yyyy-MM-dd").format(issue!.submitted),
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
    }
  }
}

