import 'package:bike_kollective/add_bike_screen.dart';
import 'package:flutter/material.dart';
import 'ui/screens/explore_bikes/explore_bikes_screen.dart';
import 'my_bikes_screen.dart';
import 'current_ride_screen.dart';
import 'bike_details_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ExploreBikesScreen(),
    const AddBikeScreen(),
    const MyBikesScreen(),
    const CurrentRideScreen(),
    const BikeDetailsScreen(),
  ];

  final List<String> _titles = [
    'Explore Available Bikes',
    'Add a Bike',
    'My Bikes',
    'Current Ride',
    'Bike Details',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add a Bike',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'My Bikes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Current Ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Bike Details',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
