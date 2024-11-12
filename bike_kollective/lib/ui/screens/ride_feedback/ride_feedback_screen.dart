import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';

class RideFeedbackScreen extends StatefulWidget {
  final RideModel ride;

  const RideFeedbackScreen({Key? key, required this.ride}) : super(key: key);

  @override
  _RideFeedbackScreenState createState() => _RideFeedbackScreenState();
}

class _RideFeedbackScreenState extends State<RideFeedbackScreen> {
  int? selectedStars;
  List<RideReviewTag> likedTags = []; // Tags for positive feedback
  List<RideReviewTag> improvementTags = []; // Tags for improvement suggestions
  TextEditingController commentController = TextEditingController();

  // Custom tag display names
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

  void submitFeedback() {
    if (selectedStars != null) {
      final review = RideReview(
        stars: selectedStars!,
        tags: likedTags + improvementTags, // Combine the tags
        comment: commentController.text,
        submitted: DateTime.now(),
      );


      // TODO: Implement logic to save the review to database
      // await Firestore.instance.collection('rides').document(widget.ride.docRef.id).update({
      //   'review': review.toMap(),
      // });
      // print('Feedback submitted: ${review.toMap()}');
      print('Feedback submitted');
      
   // Navigate back after submission
      Navigator.pop(context);
    } else {
      // Show a message to select stars
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a star rating.')),
      );
    }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

            // Positive Feedback Section
            const Text('What did you like about it?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: positiveTags.map((tag) {
                return FilterChip(
                  label: Text(tagDisplayNames[tag]!),
                  selected: likedTags.contains(tag),
                  selectedColor: Colors.blue, // Set the color when selected
                  labelStyle: TextStyle(
                    color: likedTags.contains(tag) ? Colors.white : Colors.black, // Change text color based on selection
                  ),
                  onSelected: (isSelected) {
                    toggleTag(tag);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Improvement Suggestions Section
            const Text('What could be improved?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: improvementTagsCategory.map((tag) {
                return FilterChip(
                  label: Text(tagDisplayNames[tag]!),
                  selected: improvementTags.contains(tag),
                  selectedColor: Colors.blue, // Set the color when selected
                  labelStyle: TextStyle(
                    color: improvementTags.contains(tag) ? Colors.white : Colors.black, // Change text color based on selection
                  ),
                  onSelected: (isSelected) {
                    toggleTag(tag, isImprovement: true);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text('Comments:', style: TextStyle(fontSize: 20)),
            TextField(
              controller: commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your comments here...',
              ),
            ),
            const SizedBox(height: 20),

            // Centering the Submit Button and changing its color to blue
            Center(
              child: ElevatedButton(
                onPressed: submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}