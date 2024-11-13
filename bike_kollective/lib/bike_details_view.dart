import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bike_kollective/data/model/bike_with_distance.dart';

class BikeDetailsView extends StatelessWidget {
  final BikeWithDistanceModel bike;

  const BikeDetailsView({Key? key, required this.bike}) : super(key: key);

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
        RatingBarIndicator(
          rating: 2.0,
          itemCount: 5,
          itemSize: 20.0,
          direction: Axis.horizontal,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        SizedBox(height: 8),
        Text('Owner: ${bike.owner}'),
        Text('Type: ${bike.type}'),
        Text('Status: ${bike.status}'),
        Text('Location: ${bike.locationPoint}'),
        Text('Rides: ${bike.rides}'),
        if (bike.issues.isNotEmpty) ...[
          Text('Issues: ${bike.issues.join(", ")}'),
        ],
      ],
    );
  }
}
