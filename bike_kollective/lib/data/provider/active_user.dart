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