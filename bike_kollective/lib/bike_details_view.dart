import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BikeDetailsView extends StatelessWidget {
  final BikeModel bike;
  final double? rating; // Add a rating parameter

  const BikeDetailsView({Key? key, required this.bike, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(bike.imageUrl),
        const SizedBox(height: 16),
        Text(bike.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(
          bike.description,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        
        // Use the received rating, or show a default if null
        if (rating != null) ...[
          RatingBarIndicator(
            rating: rating!,
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
        ],
        
        const SizedBox(height: 8),
        Text('Type: ${bikeTypeDisplayNames[bike.type]}'),
        Text('Status: ${bikeStatusDisplayNames[bike.status]}'),
        Text('Location: ${bike.locationPoint.latitude} latitude, ${bike.locationPoint.longitude} longitude'),
      ],
    );
  }
}