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

  void signUp(String uid) {
    // Respond to account creation with the given authentication UID
    // Note: call this in AuthStateChangeAction<UserCreated> callback
    dbAccess.addUser(UserModel.newUser(uid: uid))
    .then((user) {
      state = user;
    })
    .catchError((error) {
      // TODO - send sign up error notification to error notifier?
      state = null;
    });
  }

  void setVerified() {
    // Mark the active user as verified
    // Note: this function expects there is an active user
    // TODO - future, move to backend function that monitors email verification?
    dbAccess.updateUser(state!.copyWith(verified: DateTime.now()))
    .then((user) {
      state = user;
    })
    .catchError((error) {
      // TODO - send error notification to error notifier?
    });
  }

  void setAgreed() {
    // Mark the active user as having signed the agreement
    // Note: this function expects there is an active user
    dbAccess.updateUser(state!.copyWith(agreed: DateTime.now()))
    .then((user) {
      state = user;
    })
    .catchError((error) {
      // TODO - send error notification to error notifier?
    });
  }

  void setBanned() {
    // Mark the active user as banned
    // Note: this function expects there is an active user
    // TODO - future, move to backend function that monitors ride times?
    dbAccess.updateUser(state!.copyWith(banned: DateTime.now()))
    .then((user) {
      state = user;
    })
    .catchError((error) {
      // TODO - send error notification to error notifier?
    });
  }
}
