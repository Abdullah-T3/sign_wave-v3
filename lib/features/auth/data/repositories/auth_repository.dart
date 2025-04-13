import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../../../../core/services/base_repository.dart';

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

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("Failed to create user account.");
        // ignore: unnecessary_null_comparison
      } else if (firebaseUser != null || !firebaseUser.emailVerified) {
        await firebaseUser.sendEmailVerification();
      }

      UserModel user = UserModel(
        uid: firebaseUser.uid,
        username: username,
        fullName: fullName,
        email: email,
        phoneNumber: formattedPhoneNumber,
      );
      await saveUserData(user);
      return user;
    } catch (e) {
      log('SignUp Error: ${e.toString()}');
      rethrow;
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
    return userCredential.user!;
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

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) {
        throw Exception("User not found.");
      } else if (user != null && !user.emailVerified) {
        return UserModel(
          email: "",
          username: "",
          fullName: "",
          phoneNumber: "",
          uid: "",
        );
      } else {
        return await getUserData(user.uid);
      }
    } catch (e) {
      log('SignIn Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception("Failed to save user data.");
    }
  }

  Future<void> signOut() async {
    try {
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

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\s+'), "");
  }
}
