import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/authentication.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The different ways the app supports user sign in
enum SignInMethod { google }

// Provides updates about the user account that is signed in (if any)
final activeUserProvider = StateNotifierProvider<ActiveUserNotifier, UserModel?>((ref) {
  final authAccess = ref.watch(authenticationProvider);
  final dbAccess = ref.watch(databaseProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  return ActiveUserNotifier(authAccess, dbAccess, errorNotifier);
});

// The signed in user is determined by this class
class ActiveUserNotifier extends StateNotifier<UserModel?> {
  final Authentication authAccess;
  final BKDB dbAccess;
  final ErrorNotifier error;
  ActiveUserNotifier(this.authAccess, this.dbAccess, this.error) : super(null);

  Future<void> signOut() async {
    // Sign out of the current user's account
    await FirebaseAuth.instance.signOut();
    state = null;
  }

  Future<UserModel> signIn(SignInMethod method) async {
    // Sign in and sign up handling
    Uid uid;
    UserModel? user;

    try {
      // Get the UID from the authentication service
      if(method == SignInMethod.google) {
        uid = await authAccess.signInWithGoogle();
      } else {
        throw UnimplementedError("Missing handling for ${method.name} sign in method");
      }
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Could not authenticate user",
        logMessage: "Failed to authenticate user: $e"));
      state = null;
      rethrow;
    }
      
    try {
      // Get the user account details, null if this is a new account
      user = await dbAccess.getUserByUid(uid);
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Could not get your account",
        logMessage: "Failed to get user by UID: $e"));
      state = null;
      rethrow;
    }

    if(user == null) {
      // Create a new account if one doesn't exist yet
      try {
        user = await dbAccess.addUser(uid);
      } catch(e) {
        error.report(AppError(
          category: ErrorCategory.user,
          displayMessage: "Could not create your account",
          logMessage: "Failed to add a new user: $e"));
        state = null;
        rethrow;
      }
    }

    // Set the active user and let the caller know the sign in was successful
    state = user;
    return user;
  }

  Future<void> setVerified() async {
    try {
      state = await dbAccess.updateUser(state!.copyWith(verified: DateTime.now()));
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Could not complete verification",
        logMessage: "Failed to record user verification: $e"));
      rethrow;
    }
  }

  Future<void> setAgreed() async {
    try {
      state = await dbAccess.updateUser(state!.copyWith(agreed: DateTime.now()));
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Could not send agreement",
        logMessage: "Failed to record user agreement: $e"));
      rethrow;
    }
  }

  Future<void> setBanned() async {
    try {
      state = await dbAccess.updateUser(state!.copyWith(banned: DateTime.now()));
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        logMessage: "Failed to record user ban: $e"));
      rethrow;
    }
  }

  Future<void> setDelete() async {
    // delete account from firebase 
    User? currentUser = FirebaseAuth.instance.currentUser;

    await currentUser?.delete();
    state = null;
  }

  Future<void> setName(String newName) async {
    try {
      final updateUser = state!.copyWith(name: newName);
      state = await dbAccess.updateUser(updateUser);
    } catch(e) {
      error.report(AppError(
        category: ErrorCategory.user,
        displayMessage: "Could not update your name.",
        logMessage: "Failed to update user name: $e",
      ));
      rethrow;
    }
  }
}
