import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/active_user.dart';

class AuthenticationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the active user provider
    final activeUser = ref.watch(activeUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Authenticate"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Get the notifier from the provider and call signIn
            final notifier = ref.read(activeUserProvider.notifier);
            await notifier.signIn();
            
            if (activeUser != null) {
              // Proceed to the next screen or perform necessary actions
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: Text("Sign In with Google"),
        ),
      ),
    );
  }
}
