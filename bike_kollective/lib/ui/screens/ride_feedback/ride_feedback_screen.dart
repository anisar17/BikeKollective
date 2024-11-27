import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/provider/active_ride.dart';

class RideFeedbackScreen extends ConsumerWidget {
  final RideModel ride; // Named parameter for the ride

  // Constructor using a named parameter
  const RideFeedbackScreen({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Feedback'),
      ),
      body: _RideFeedbackForm(ride: ride, ref: ref), // Pass ref to the form
    );
  }
}

class _RideFeedbackForm extends StatefulWidget {
  final RideModel ride;
  final WidgetRef ref; // Pass WidgetRef to the form

  const _RideFeedbackForm({Key? key, required this.ride, required this.ref}) : super(key: key);

  @override
  _RideFeedbackFormState createState() => _RideFeedbackFormState();
}

class _RideFeedbackFormState extends State<_RideFeedbackForm> {
  // Initialize selectedStars and lists
  int? selectedStars;
  List<RideReviewTag> likedTags = [];
  List<RideReviewTag> improvementTags = [];
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<RideReviewTag, String> tagDisplayNames = {
    RideReviewTag.funToRide: 'Fun to Ride',
    RideReviewTag.wellMaintained: 'Well Maintained',
    RideReviewTag.fast: 'Fast',
    RideReviewTag.comfortable: 'Comfortable',
    RideReviewTag.looksGood: 'Looks Good',
    RideReviewTag.brokeDown: 'Broke Down',
    RideReviewTag.uncomfortable: 'Uncomfortable',
    RideReviewTag.needsATuneUp: 'Needs a Tune-Up',
    RideReviewTag.tooSlow: 'Too Slow',
  };

  void toggleTag(RideReviewTag tag, {bool isImprovement = false}) {
    setState(() {
      if (isImprovement) {
        if (improvementTags.contains(tag)) {
          improvementTags.remove(tag);
        } else {
          improvementTags.add(tag);
        }
      } else {
        if (likedTags.contains(tag)) {
          likedTags.remove(tag);
        } else {
          likedTags.add(tag);
        }
      }
    });
  }

  Future<void> submitFeedback() async {
    if (_formKey.currentState!.validate() && selectedStars != null) {
      final review = RideReview(
        stars: selectedStars!,
        tags: likedTags + improvementTags,
        comment: commentController.text.isNotEmpty ? commentController.text : '', // Set to empty string if empty
        submitted: DateTime.now(),
      );

      final activeRideNotifier = widget.ref.read(activeRideProvider.notifier); // Use passed ref
      try {
        await activeRideNotifier.finishRide(review);
        Navigator.pop(context); // Navigate back after submission
      } catch (e) {
        // Log the error message and show a snackbar
        debugPrint("Error in finishRide: $e");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error submitting feedback. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating.')),
      );
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final positiveTags = [
      RideReviewTag.funToRide,
      RideReviewTag.wellMaintained,
      RideReviewTag.fast,
      RideReviewTag.comfortable,
      RideReviewTag.looksGood,
    ];

    final improvementTagsCategory = [
      RideReviewTag.brokeDown,
      RideReviewTag.uncomfortable,
      RideReviewTag.needsATuneUp,
      RideReviewTag.tooSlow,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rate your ride:', style: TextStyle(fontSize: 20)),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < (selectedStars ?? 0) ? Icons.star : Icons.star_border,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              const Text('What did you like about it?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: positiveTags.map((tag) {
                  return FilterChip(
                    label: Text(tagDisplayNames[tag]!),
                    selected: likedTags.contains(tag),
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: likedTags.contains(tag) ? Colors.white : Colors.black,
                    ),
                    onSelected: (isSelected) {
                      toggleTag(tag);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Text('What could be improved?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: improvementTagsCategory.map((tag) {
                  return FilterChip(
                    label: Text(tagDisplayNames[tag]!),
                    selected: improvementTags.contains(tag),
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: improvementTags.contains(tag) ? Colors.white : Colors.black,
                    ),
                    onSelected: (isSelected) {
                      toggleTag(tag, isImprovement: true);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Text('Comments:', style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your comments here...',
                ),
                // Comments are optional
                validator: (value) {
                  return null; // Return null to indicate that the comments are not required
                },
              ),

              ElevatedButton(
                onPressed: () async {
                  await submitFeedback();  // Wait for the feedback submission to complete
                  Navigator.pushReplacementNamed(context, '/home');  // Navigate to the home screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}