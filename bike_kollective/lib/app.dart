import 'package:bike_kollective/authentication_screen.dart';
import 'package:bike_kollective/ui/waiver_screen/waiver_screen.dart';
import 'package:bike_kollective/ui/current_ride/current_ride_screen.dart';
import 'package:bike_kollective/ui/email_verification/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Bike Kollective',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/waiver': (context) => WaiverScreen(),
        '/email': (context) => const EmailVerificationScreen(),
        '/home': (context) => const MyHomePage(),
        '/auth': (context) => AuthenticationScreen(),
        '/currentRide': (context) => CurrentRideScreen(),
      }
    );
  }
}
