import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sign_wave_v3/core/services/di.dart';
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
        throw Exception("error_email_already_exists");
      }
      if (await checkPhoneExists(formattedPhoneNumber)) {
        throw Exception("error_phone_already_exists");
      }
      if (await checkUserExists(username)) {
        throw Exception("error_username_already_exists");
      }
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("error_signup_failed");
      } else if (!firebaseUser.emailVerified) {
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
        throw Exception(FirebaseAuthErrorHandler.getLocalizedErrorKey(e));
      } else if (e is Exception) {
        // Check if it's already a localized error key
        if (e.toString().startsWith('error_')) {
          rethrow;
        }
        throw Exception("error_signup_failed");
      } else {
        throw Exception("error_signup_failed");
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
      throw Exception("error_signin_failed");
    }

    // Only update FCM token if email is verified
    if (userCredential.user!.emailVerified) {
      final fcmToken = getIt.get<String>(instanceName: 'fcmToken');
      await firestore.collection("users").doc(userCredential.user!.uid).update({
        'fcmToken': fcmToken,
      });
    }

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
      // Try to create a user with the email to check if it exists
      // This is a more secure approach than fetchSignInMethodsForEmail
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: "temp_password",
      );
      // If successful, delete the temporary user
      await auth.currentUser?.delete();
      return false; // Email doesn't exist (we just created it)
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        return true; // Email already exists
      }
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
      throw Exception("error_save_user_data_failed");
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception("error_update_user_data_failed");
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
      // JitsiCallService().dispose();
      await auth.signOut();
    } catch (e) {
      log('SignOut Error: ${e.toString()}');
      throw Exception("error_signout_failed");
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      log('DEBUG: Fetching user document for UID: $uid');
      var doc = await firestore.collection("users").doc(uid).get();
      log('DEBUG: Document exists: ${doc.exists}');
      if (!doc.exists) {
        log('DEBUG: User document not found in Firestore');
        throw Exception("error_user_data_not_found");
      }
      log('DEBUG: User document data: ${doc.data()}');
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
      if (e is FirebaseAuthException) {
        throw Exception(FirebaseAuthErrorHandler.getLocalizedErrorKey(e));
      } else {
        throw Exception("error_password_reset_failed");
      }
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\s+'), "");
  }

  Future<void> deleteAccount() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw Exception("error_no_user_signed_in");
      }

      final uid = currentUser.uid;

      await currentUser.delete();

      await _deleteUserData(uid);

      log('Account deleted successfully for user: $uid');
    } catch (e) {
      log('DeleteAccount Error: ${e.toString()}');
      if (e is FirebaseAuthException) {
        throw Exception(FirebaseAuthErrorHandler.getLocalizedErrorKey(e));
      } else if (e is Exception) {
        // Check if it's already a localized error key
        if (e.toString().startsWith('error_')) {
          rethrow;
        }
        throw Exception("error_delete_account_failed");
      } else {
        throw Exception("error_delete_account_failed");
      }
    }
  }

  Future<void> _deleteUserData(String uid) async {
    try {
      await firestore.collection("users").doc(uid).delete();

      final chatRoomsQuery =
          await firestore
              .collection("chatRooms")
              .where("participants", arrayContains: uid)
              .get();

      for (var doc in chatRoomsQuery.docs) {
        await doc.reference.delete();
      }

      // Delete user's messages
      final messagesQuery =
          await firestore
              .collection("messages")
              .where("senderId", isEqualTo: uid)
              .get();

      for (var doc in messagesQuery.docs) {
        await doc.reference.delete();
      }

      // Delete user's contacts
      final contactsQuery =
          await firestore
              .collection("contacts")
              .where("ownerUid", isEqualTo: uid)
              .get();

      for (var doc in contactsQuery.docs) {
        await doc.reference.delete();
      }

      log('User data deleted successfully for user: $uid');
    } catch (e) {
      log('Error deleting user data: ${e.toString()}');
      throw Exception("error_delete_user_data_failed");
    }
  }
}
