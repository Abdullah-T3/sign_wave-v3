import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sign_wave_v3/core/services/di.dart';
import 'package:sign_wave_v3/core/services/zegoCloud_call.dart';
import '../models/user_model.dart';
import '../../../../../core/services/base_repository.dart';
import '../../../../../core/error/firebase_auth_error_handling.dart';

class AuthRepository extends BaseRepository {
  Stream<User?> get authStateChanges => auth.authStateChanges();
  Future<UserModel> signUp({
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final formattedPhoneNumber = formatPhoneNumber(phoneNumber);

      if (await checkEmailExists(email)) {
        throw Exception("An account with the same email already exists.");
      }
      if (await checkPhoneExists(formattedPhoneNumber)) {
        throw Exception(
          "An account with the same phone number already exists.",
        );
      }
      if (await checkUserExists(username)) {
        throw Exception("An account with the same username already exists.");
      }
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("Failed to create user account.");
      } else if (firebaseUser != null || !firebaseUser.emailVerified) {
        await firebaseUser.sendEmailVerification();
      }
      UserModel user = UserModel(
        uid: firebaseUser.uid,
        username: username,
        fullName: fullName,
        email: email,
        phoneNumber: formattedPhoneNumber,
        fcmToken: getIt.get<String>(instanceName: 'fcmToken'),
      );
      await saveUserData(user);
      return user;
    } catch (e) {
      log('SignUp Error: ${e.toString()}');
      if (e is FirebaseAuthException) {
        throw Exception(FirebaseAuthErrorHandler.handleError(e));
      } else if (e is Exception) {
        throw Exception(FirebaseAuthErrorHandler.handleGeneralError(e));
      } else {
        throw Exception("Failed to create user account.");
      }
    }
  }

  Future<User> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user == null) {
      throw Exception("Failed to sign in.");
    } else if (!userCredential.user!.emailVerified) {
      throw Exception("Email is not verified.");
    }
    final fcmToken = getIt.get<String>(instanceName: 'fcmToken');
    print("fcmToken in sign in: $fcmToken");
    await firestore.collection("users").doc(userCredential.user!.uid).update({
      'fcmToken': fcmToken,
    });
    return userCredential.user!;
  }

  Future<bool> checkUserExists(String username) async {
    try {
      var querySnapshot =
          await firestore
              .collection("users")
              .where("username", isEqualTo: username)
              .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log("Error checking username existence: ${e.toString()}");
      return false;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      List<String> methods = await auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      log("Error checking email existence: ${e.toString()}");
      return false;
    }
  }

  Future<bool> checkPhoneExists(String phoneNumber) async {
    try {
      var querySnapshot =
          await firestore
              .collection("users")
              .where("phoneNumber", isEqualTo: phoneNumber)
              .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log("Error checking phone number existence: ${e.toString()}");
      return false;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception("Failed to save user data.");
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).update(user.toMap());
      print("success updating user data");
    } catch (e) {
      throw Exception("Failed to update user data.");
    }
  }

  Future<void> signOut() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        await firestore.collection("users").doc(currentUser.uid).update({
          'fcmToken': "",
        });
      }
      await FirebaseMessaging.instance.deleteToken();
      onUserLogout();
      await auth.signOut();
    } catch (e) {
      log('SignOut Error: ${e.toString()}');
      throw Exception("Failed to sign out.");
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      var doc = await firestore.collection("users").doc(uid).get();
      if (!doc.exists) {
        throw Exception("User data not found.");
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      log('GetUserData Error: ${e.toString()}');
      rethrow;
    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log('SendPasswordResetEmail Error: ${e.toString()}');
      throw Exception("Failed to send password reset email.");
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\s+'), "");
  }
}
