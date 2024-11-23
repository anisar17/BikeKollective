import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// A UID is a string that uniquely identifies an authenticated user
typedef Uid = String;

// Provides access to the authentication services
final authenticationProvider = Provider<Authentication>((ref) {
  //return DummyAuthentication(); // Uncomment to work with dummy data instead of real auth
  return RealAuthentication();
});

// Interface for doing authentication
abstract class Authentication {
  Future<Uid> signInWithGoogle();
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DummyAuthentication in the authenticationProvider above
class DummyAuthentication extends Authentication {
  @override
  Future<Uid> signInWithGoogle() async {
    return "DUMMY_GOOGLE_USER";
  }
}

// This implementation requests
class RealAuthentication extends Authentication {
  @override
  Future<Uid> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credentials);
    return userCredential.user!.uid;
  }
}
