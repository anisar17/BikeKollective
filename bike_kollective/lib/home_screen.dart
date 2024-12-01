import 'package:bike_kollective/data/provider/active_ride.dart';
import 'package:bike_kollective/data/provider/available_bikes.dart';
import 'package:bike_kollective/data/provider/owned_bikes.dart';
import 'package:bike_kollective/edit_bike_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/explore_bikes/explore_bikes_screen.dart';
import 'ui/my_bikes_screen/my_bikes_screen.dart';
import 'ui/current_ride/current_ride_screen.dart';
import 'ui/user_account/user_account_screen.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ExploreBikesScreen(),
    const EditBikeScreen(),
    const MyBikesScreen(),
    CurrentRideScreen(),
    const UserAccountScreen(),
  ];

  final List<String> _titles = [
    'Explore Available Bikes',
    'Add a Bike',
    'My Bikes',
    'Current Ride',
  ];

  Future<void> _onItemTapped(int index) async {
    // Refresh page content on tap
    if(index == 0) {
      await ref.read(availableBikesProvider.notifier).refresh();
    } else if(index == 2) {
      await ref.read(ownedBikesProvider.notifier).refresh();
    } else if(index == 4) {
      await ref.read(activeRideProvider.notifier).refresh();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bike Kollective',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserAccountScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Explore Bikes',
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
