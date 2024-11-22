import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides updates about the user account that is logged in (if any)
final activeUserProvider = StateNotifierProvider<ActiveUserNotifier, UserModel?>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  return ActiveUserNotifier(dbAccess, errorNotifier);
});

// The logged-in user is determined by this class
class ActiveUserNotifier extends StateNotifier<UserModel?> {
  final BKDB dbAccess;
  final ErrorNotifier error;
  ActiveUserNotifier(this.dbAccess, this.error) : super(null);

  void signOut() {
    // Log out of the current user's account
    state = null;
  }

  Future<void> signIn(String uid) async {
    try {
      // Sign in to users account using UID
      state = await dbAccess.getUserByUid(uid);
      } catch(e) {
        error.report(AppError(
          category: ErrorCategory.user,
          displayMessage: "Could not get user UID",
          logMessage: "Could not get user by UID"));
        state = null;
      }
    }

  Future<void> signUp(String uid) async {
    // Respond to account creation with the given authentication UID
    // Note: call this in AuthStateChangeAction<UserCreated> callback
    try {
      state = await dbAccess.addUser(uid);
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Could not create new user.",
        logMessage: "Failed to add a new user."));
      state = null;
    }
  }

  Future<void> setVerified() async {
    // Mark the active user as verified
    // Note: this function expects there is an active user
    // TODO - future, move to backend function that monitors email verification?
    // We do not have connection to email verification so this isn't implemented yet
    try {
      state = await dbAccess.updateUser(state!.copyWith(verified: DateTime.now()));
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Email has not been verified.",
        logMessage: "User has not verified email."));
      state = null;
    }
  }

  Future<void> setAgreed() async {
    // Mark the active user as having signed the agreement
    // Note: this function expects there is an active user
    try {
      state = await dbAccess.updateUser(state!.copyWith(agreed: DateTime.now()));
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "You have not signed the agreement.",
        logMessage: "User has not signed the waiver yet."));
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
      error.report(AppError(
        category: ErrorCategory.user,
        logMessage: "User is not banned."));
      state = null;
    }
  }
}
