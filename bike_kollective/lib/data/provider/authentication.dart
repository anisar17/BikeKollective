import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A UID is a string that uniquely identifies an authenticated user
typedef Uid = String;
typedef Email = String;
typedef Password = String;

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
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = 
      await FirebaseAuth.instance.signInWithCredential(credentials);

    String uid = userCredential.user!.uid;
    String? email = userCredential.user?.email;
    print(userCredential.user!.uid);
    print(userCredential.user!.email);

    return AuthResult(
      uid: uid, 
      email: email,
    );
  }
}

class AuthResult {
  final String uid;
  final String? email;

  AuthResult({required this.uid, this.email});
}

// Provides access to login with email
final emailAuthProvider = Provider<EmailAuthentication>((ref) {
  return RealEmailAuthentication();
});

abstract class EmailAuthentication {
  Future<EmailResult?> createUserWithEmailAndPassword(String email, String password);
}

class RealEmailAuthentication extends EmailAuthentication {
  final _auth = FirebaseAuth.instance;

  @override
  Future<EmailResult> createUserWithEmailAndPassword(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    AuthCredential credentials = EmailAuthProvider.credential(
      email: email, 
      password: password
    );
    
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credentials);

    String uid = userCredential.user!.uid;
    String? emailUser = userCredential.user!.email;
    print(uid);
    print(emailUser);

    return EmailResult(
      uid: uid, 
      email: email, 
      password: password);
  }
}

class EmailResult {
  final Uid uid;
  final Email email;
  final Password password;

  EmailResult({required this.uid, required this.email, required this.password});
}
