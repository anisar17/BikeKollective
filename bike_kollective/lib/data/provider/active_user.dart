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

  void signIn(String uid) {
    // Respond to successful login with the given authentication UID
    dbAccess.getUserByUid(uid)
    .then((user) {
      state = user;
    })
    .catchError((error) {
      // TODO - send sign in error notification to error notifier?
      state = null;
    });
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
    // TODO - update user as verified
    // TODO - future, move to backend function that monitors email verification?
  }

  void setAgreed() {
    // TODO - update user as agreed
  }

  void setBanned() {
    // TODO - update user as banned
    // TODO - future, move to backend function that monitors ride times?
  }
}