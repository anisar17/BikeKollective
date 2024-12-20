import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/provider/available_bikes.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/owned_bikes.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:bike_kollective/edit_bike_screen.dart';
import 'package:bike_kollective/ui/widgets/bike_issue_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'bike_details_view.dart';

// Provides the active issue for the displayed bike, null if no issue
final _activeIssueProvider = StateNotifierProvider<_ActiveIssueNotifier, IssueModel?>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  return _ActiveIssueNotifier(dbAccess, locAccess, errorNotifier); 
});

// Note: there can only be one active issue at a time for a given bike
class _ActiveIssueNotifier extends StateNotifier<IssueModel?> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final ErrorNotifier errorNotifier;
  BikeModel? bike;
  _ActiveIssueNotifier(this.dbAccess, this.locAccess, this.errorNotifier) : super(null);

  Future<void> setBike(BikeModel bike) async {
    this.bike = bike;
    try {
      if(bike.status == BikeStatus.hasIssue) {
        state = await dbAccess.getActiveIssueForBike(bike);
      } else {
        state = null;
      }
    } catch(e) {
      errorNotifier.report(AppError(
        category: ErrorCategory.database,
        displayMessage: "Could not get issue for bike",
        logMessage: "Could not get issue for bike: $e"));
      state = null;
      rethrow;
    }
  }

  Future<void> resolveIssue() async {
    try {
      var point = await locAccess.getCurrent();
      try {
        var time = DateTime.now();
        // Mark the issue resolved
        await dbAccess.updateIssue(state!.copyWith(resolved: time));
        // Restore the bike to being available at the owner's location
        await dbAccess.updateBike(bike!.copyWith(
          status: BikeStatus.available,
          locationPoint: point,
          locationUpdated: time));
        // Resolving an issue makes it no longer active
        state = null;
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not resolve issue",
          logMessage: "Could not resolve issue: $e"));
        rethrow;
      }
    } catch(e) {
      errorNotifier.report(AppError(
        category: ErrorCategory.location,
        displayMessage: "Could not get user location",
        logMessage: "Could not get user location: $e"));
      rethrow;
    }
  }
}

class MyBikeDetailsScreen extends ConsumerStatefulWidget {
  BikeModel bike;
  MyBikeDetailsScreen({super.key, required this.bike});

  @override
  MyBikeDetailsScreenState createState() => MyBikeDetailsScreenState();
}

class MyBikeDetailsScreenState extends ConsumerState<MyBikeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(_activeIssueProvider.notifier).setBike(widget.bike);
  }

  @override
  Widget build(BuildContext context) {
    IssueModel? issue = ref.watch(_activeIssueProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bike.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BikeDetailsView(bike: widget.bike),
            const Spacer(),
            BikeIssueView(bike: widget.bike, issue: issue),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(ownedBikesProvider.notifier).removeBike(widget.bike);
                    // Refresh the list of available bikes to remove this bike
                    await ref.read(availableBikesProvider.notifier).refresh();
                    // Navigate back to home screen
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(issue != null) {
                      ref.read(_activeIssueProvider.notifier).resolveIssue();
                    }
                    setState(() {
                      widget.bike = widget.bike.copyWith(status: BikeStatus.available);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the edit screen for this bike
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBikeScreen(oldBike: widget.bike),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    ' Edit ',
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