import 'dart:math';

import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A UID is a string that uniquely identifies an authenticated user
typedef Uid = String;
typedef Email = String?;

// Provides access to the authentication services
final authenticationProvider = Provider<Authentication>((ref) {
  //return DummyAuthentication(); // Uncomment to work with dummy data instead of real auth
  return RealAuthentication();
});

// Interface for doing authentication
abstract class Authentication {
  Future<AuthResult?> signInWithGoogle();
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DummyAuthentication in the authenticationProvider above
class DummyAuthentication extends Authentication {
  @override
  Future<AuthResult> signInWithGoogle() async {
    return AuthResult(uid: "Dummer_UID", email: "Dummy_Email");
  }
}

// This implementation requests
class RealAuthentication extends Authentication {
  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // get access tokens
      AuthCredential credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credentials);

      // get UID and email
      String? uid = userCredential.user?.uid;
      String? email = userCredential.user?.email;

      // check if user exists
      if (uid != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          if (!userDoc.exists) {
          // If the user doesn't exist, create a new user in Firestore
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'email': email,
            'displayName': userCredential.user?.displayName,
            // Add other default fields if needed
          });
        }

        // Return AuthResult with UID and Email
        return AuthResult(
          uid: uid,
          email: email,
        );
      }
    } catch (e) {
      // Handle any errors (e.g., log or display a message)
      print('Error during Google Sign-In: $e');
    }
  }
}
}

class AuthResult {
  final Uid uid;
  final Email email;

  AuthResult({required this.uid, required this.email});
}