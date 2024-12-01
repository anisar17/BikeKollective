import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/authentication.dart';
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
          children: [
            // Title Section at the top
            const Expanded(
              flex: 1,
              child: Center (
                child: Text(
                  'The Bike Kollective',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, 
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Member Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
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
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          if (email.isNotEmpty && password.isNotEmpty) {
                            try {
                              final user = await ref.read(activeUserProvider.notifier).signIn(SignInMethod.email, email: email, password: password);
                              if (!user.isAgreed()) {
                                Navigator.pushReplacementNamed(context, '/waiver');
                              } else if (!user.isVerified()) {
                                Navigator.pushReplacementNamed(context, '/email');
                              } else {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Login Failed: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton( 
                        onPressed: () async  {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          if (email.isNotEmpty && password.isNotEmpty) {
                            try {
                              final authAccess = ref.read(authenticationProvider);
                              final authResult = await authAccess.createUserWithEmailAndPassword(email, password);
                              final user = await ref.read(activeUserProvider.notifier).signIn(SignInMethod.email, email: email, password: password);
                              if (!user.isAgreed()) {
                                Navigator.pushReplacementNamed(context, '/waiver');
                              } else if (!user.isVerified()) {
                                Navigator.pushReplacementNamed(context, '/email');
                              } else {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Registration Failed: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'The Bike Kollective user account is linked to your Google account to verify and authenticate your account information.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          UserModel user = await ref.read(activeUserProvider.notifier).signIn(SignInMethod.google);
                          if (user.isBanned()) {
                            throw UnimplementedError("Missing Handling for banned users.");
                          } else if (!user.isAgreed()) {
                            Navigator.pushReplacementNamed(context, '/waiver');
                          } else if (!user.isVerified()) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
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
            ),
          ],
        ),
      ),
    );
  }
}