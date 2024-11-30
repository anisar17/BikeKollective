import 'package:bike_kollective/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/provider/active_user.dart';

class AuthenticationScreen extends ConsumerWidget {

  AuthenticationScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 65, 176), // Blue at the top
              Colors.white, // White at the bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Section at the top
            const Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'The Bike Kollective',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            const Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Member Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // Login Button and Description at the bottom
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async{
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        if (email.isNotEmpty && password.isNotEmpty) {
                          try {
                            UserModel user = await ref.read(activeUserProvider.notifier).signIn(SignInMethod.email, email: email, password: password);
                            if (user.isBanned()) {
                              // deal with user being banned banned screen??
                              throw UnimplementedError("Missing handling for banned users");
                            } else if (!user.isAgreed()) {
                              // If user hasn't signed agreement navigate to waiver page
                              Navigator.pushReplacementNamed(context, '/waiver');
                            } else if (!user.isVerified()) {
                              // TODO: handle email verification
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          } catch (e) {
                            print("Error during sign-in: $e");
                          }
                        } else {
                          print("Email or password cannot be empty");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ), 
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'The Bike Kollective user account is linked to your Google account to verify and authenticate your information.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        // Currently, we only support login using Google credentials.
                        UserModel user = await ref.read(activeUserProvider.notifier).signIn(SignInMethod.google);
                        // Show the user the next screen depending on the state of their account.
                        if(user.isBanned()) {
                          // The user has been banned, show them a screen that
                          // lets them know and prevents them from using the app.
                          // TODO: navigate to a banned screen
                          throw UnimplementedError("Missing handling for banned users");
                        } else if(!user.isAgreed()) {
                          // The user has not yet signed an agreement, or 
                          // needs to sign a new one. We need to show that
                          // before they can use the app.
                          Navigator.pushReplacementNamed(context, '/waiver');
                        } else if(!user.isVerified()) {
                          // The user has not yet verified their email.
                          // TODO: handle verification step
                          // TODO: remove below, for now allow unverified users
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          // The user is ready, go to the main screen.
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Google Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}