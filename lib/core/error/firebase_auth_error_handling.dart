import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorHandler {
  static String handleError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'The password is invalid.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      case 'invalid-credential':
        return 'The credential is malformed or has expired.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'invalid-action-code':
        return 'The action code is invalid.';
      case 'invalid-continue-uri':
        return 'The continue URI is invalid.';
      case 'invalid-dynamic-link-domain':
        return 'The dynamic link domain is invalid.';
      default:
        return 'An error occurred: ${error.message}';
    }
  }

  static String handleGeneralError(Exception error) {
    return 'An unexpected error occurred: ${error.toString()}';
  }
}
