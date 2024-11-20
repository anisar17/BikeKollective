import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/authentication_screen.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/home_screen.dart';

class VerifyEmailScreen extends StatelessWidget{

  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () => Get.offAll(() => const AuthenticationScreen()), icon: const Icon(CupertinoIcons.clear))],
      ),
      body: Container(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify your Email Address',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
                )
            )
          ],),
      )
    );

  }
}