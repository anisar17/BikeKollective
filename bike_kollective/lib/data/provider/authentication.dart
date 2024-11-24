import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<AuthResult> signInWithGoogle();
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
    if (googleUser == null) {
      throw Exception("Google sign-in stopped.");
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // add checks for null variables
    if (googleAuth.idToken == null) {
      throw Exception("Null access tokens");
    }
    // get access tokens
    AuthCredential credentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken!,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credentials);
    User? firebaseUser = userCredential.user;
    // check firebase database for user
    if (firebaseUser == null) {
      throw Exception("Firebase user null after signin.");
    } 
    if (firebaseUser.email == null || firebaseUser.uid.isEmpty) {
      throw Exception("User is missing email or UID");
    }
    return AuthResult(uid: firebaseUser.uid, email: firebaseUser.email);
  }
}

class AuthResult {
  final Uid uid;
  final Email email;

  AuthResult({required this.uid, required this.email});
}
