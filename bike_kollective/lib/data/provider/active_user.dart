import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides updates about the user account that is logged in (if any)
final activeUserProvider = StateNotifierProvider<ActiveUserNotifier, UserModel?>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  return ActiveUserNotifier(dbAccess);
});

// The logged in user is determined by this class
class ActiveUserNotifier extends StateNotifier<UserModel?> {
  final BKDB dbAccess;
  ActiveUserNotifier(this.dbAccess) : super(null);

  void signOut() {
    // Log out of the current user's account
    state = null;
  }

  void signIn(final String uid) {
    // Respond to successful login with the given authentication UID
    // TODO - handle error accessing database
    dbAccess.getUserByUid(uid).then((user) {state = user;});
  }

  void signUp(String uid) {
    // Respond to account creation with the given authentication UID
    // Note: call this in AuthStateChangeAction<UserCreated> callback

    // The new user is created needing verification and agreement signing
    var newUser = UserModel(uid: uid, verified: null, agreed: null, banned: null, points: 0, owns: [], rides: []);
    // Create a database entry for the user
    // TODO - handle error accessing database
    dbAccess.addUser(newUser).then((_) {state = newUser;});
  }
}