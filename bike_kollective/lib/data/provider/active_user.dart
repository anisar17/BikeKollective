import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provides updates about the user account that is logged in (if any)
final activeUserProvider = StateNotifierProvider<ActiveUserNotifier, UserModel?>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  return ActiveUserNotifier(dbAccess);
});

// The logged-in user is determined by this class
class ActiveUserNotifier extends StateNotifier<UserModel?> {
  final BKDB dbAccess;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  ActiveUserNotifier(this.dbAccess) : super(null);

  void signOut() {
    // Log out of the current user's account
    _googleSignIn.signOut();
    state = null;
  }

  Future<void> signIn() async {
    try {
      // Initiate the Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        state = null;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        // Fetch user from the database or use dummy data for testing
        final user = await dbAccess.getUserByUid(googleUser.id);
        
        // If user is null, create a dummy user for testing
        state = user ?? UserModel.newUser(uid: googleUser.id);
      } else {
        state = null;
      }
    } catch (error) {
      // Handle any other errors in the sign-in process
      state = null;
    }
  }
}
