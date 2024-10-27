import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Sample bike model
class BikeModel {
  final String name;
  final String description;
  final String imageUrl;

  BikeModel({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

// Sample data
final List<BikeModel> bikeList = [
  BikeModel(
    name: 'Mountain Bike',
    description: 'A bike that can handle rough trails.',
    imageUrl: 'https://example.com/mountain_bike.png', // Replace with actual image URL
  ),
  BikeModel(
    name: 'Road Bike',
    description: 'A lightweight bike designed for speed on paved roads.',
    imageUrl: 'https://example.com/road_bike.png', // Replace with actual image URL
  ),
  // Add more bike models as needed
];

class BikeDetailsScreen extends ConsumerWidget {
  const BikeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Details'),
      ),
      body: ListView.separated(
        itemCount: bikeList.length,
        separatorBuilder: (context, index) {
          return const Divider(height: 10);
        },
        itemBuilder: (context, index) {
          final bike = bikeList[index];
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display bicycle image
                Image.network(
                  bike.imageUrl,
                  width: 200, // Adjust as needed
                  height: 120, // Adjust as needed
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                // Display bicycle name
                Text(
                  bike.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // Display bicycle description
                Text(bike.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
/*
class BikeDetailsScreen extends ConsumerWidget {
  const BikeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Note the addition of `WidgetRef`
    return const Center(
      child: Text('Bike Details Screen'),
    );
  }
}
*/

/*
// An interactive list of reviews and review forms
class ReviewsList extends ConsumerWidget {
  const ReviewsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider);
    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (context, index) {
        return const Divider(height: 10);
      },
      itemBuilder: (context, index) {
        final review = reviews[index].copyWith();
        if(review.displayMode == DisplayMode.form) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: ReviewEntryForm(
              initialData: review,
              onCancel: (int id) {ref.read(reviewsProvider.notifier).cancelReviewEdit(id);},
              onSubmit: (int id, ReviewModel m) {ref.read(reviewsProvider.notifier).submitReviewEdit(id, m);}));
        }
        else if(review.displayMode == DisplayMode.map) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: ReviewEntryMap(
              initialData: review,
              onCancel: (int id) {ref.read(reviewsProvider.notifier).cancelPlaceSelect(id);},
              onSubmit: (int id, Place p) {ref.read(reviewsProvider.notifier).submitPlaceSelect(id, p);}));
        }
        else {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: ReviewEntry(
              data: review,
              onEdit: (int id) {ref.read(reviewsProvider.notifier).beginReviewEdit(id);},
              onDelete: (int id) {ref.read(reviewsProvider.notifier).deleteReview(id);}));
        }
      },
    );
  }
}
*/
 