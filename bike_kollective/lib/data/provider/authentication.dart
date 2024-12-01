import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithEmailAndPassword(String email, String password);
  Future<AuthResult> createUserWithEmailAndPassword(String email, String password);
}

// This implementation can be used by developers to create fake data
// Note: be sure to return DummyAuthentication in the authenticationProvider above
class DummyAuthentication extends Authentication {
  @override
  Future<AuthResult> signInWithGoogle() async {
    return AuthResult(uid: "Dummer_UID", email: "Dummy_Email");
  }
  @override
  Future<AuthResult> signInWithEmailAndPassword(email, password) async {
    return AuthResult(uid: "Dummy UID", email: "dummy_email2");
  }
  @override
  Future<AuthResult> createUserWithEmailAndPassword(email, password) async{
    return AuthResult(uid: "Dumb UID", email: "dumb_email");
  }
}

// This implementation requests
class RealAuthentication extends Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    return AuthResult(
      uid: userCredential.user!.uid,
      email: userCredential.user?.email,
    );
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    return AuthResult(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email,
    );
  }
}

class AuthResult {
  final String uid;
  final String? email;

  AuthResult({required this.uid, this.email});
}

