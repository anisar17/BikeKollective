import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/provider/active_user.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override 
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  bool isLoading = false;

  @override 
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check your email for the verification link.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification email: $e')),
      );
    }
  }

  Future<void> _checkVerificationStatus() async {
    setState(() {
      isLoading = true;
    });

  try {
    await FirebaseAuth.instance.currentUser?.reload();
    final isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (isVerified) {
      await ref.read(activeUserProvider.notifier).setVerified();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email has not been verified.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error checking verification status: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

@override 
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A verification email has been sent to your email address.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendVerificationEmail,
              child: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _checkVerificationStatus, 
              child: isLoading ? const CircularProgressIndicator() : const Text('Check verification status'),
            ),
            ],
          ),
        ),
      ),
    );
  }
}