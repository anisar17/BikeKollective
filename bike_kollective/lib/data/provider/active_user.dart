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

  Future<void> signIn(String uid) async {
    // Respond to successful login with the given authentication UID
    try {
      state = await dbAccess.getUserByUid(uid);
    } catch(e) {
      // TODO - send sign in error notification to error notifier
      state = null;
    }
  }

  Future<void> signUp(String uid) async {
    // Respond to account creation with the given authentication UID
    // Note: call this in AuthStateChangeAction<UserCreated> callback
    try {
      state = await dbAccess.addUser(UserModel.newUser(uid: uid));
    } catch(e) {
      // TODO - send sign up error notification to error notifier
      state = null;
    }
  }

  Future<void> setVerified() async {
    // Mark the active user as verified
    // Note: this function expects there is an active user
    // TODO - future, move to backend function that monitors email verification?
    try {
      state = await dbAccess.updateUser(state!.copyWith(verified: DateTime.now()));
    } catch(e) {
      // TODO - send sign up error notification to error notifier
      state = null;
    }
  }

  Future<void> setAgreed() async {
    // Mark the active user as having signed the agreement
    // Note: this function expects there is an active user
    try {
      state = await dbAccess.updateUser(state!.copyWith(agreed: DateTime.now()));
    } catch(e) {
      // TODO - send error notification to error notifier
      state = null;
    }
  }

  Future<void> setBanned() async {
    // Mark the active user as banned
    // Note: this function expects there is an active user
    // TODO - future, move to backend function that monitors ride times?
    try {
      state = await dbAccess.updateUser(state!.copyWith(banned: DateTime.now()));
    } catch(e) {
      // TODO - send error notification to error notifier
      state = null;
    }
  }
}