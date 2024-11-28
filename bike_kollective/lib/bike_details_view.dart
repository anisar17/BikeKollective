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
        SizedBox(height: 16),
        Text(
          bike.description,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),
        Text(bike.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        
        // Use the received rating, or show a default if null
        if (rating != null) ...[
          RatingBarIndicator(
            rating: rating!,
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
        ],
        
        SizedBox(height: 8),
        Text('Owner: ${bike.owner}'),
        Text('Type: ${bike.type}'),
        Text('Status: ${bike.status}'),
        Text('Location: ${bike.locationPoint}'),
      ],
    );
  }
}