import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class FirebaseAuthErrorHandler {
  static String handleError(FirebaseAuthException error, BuildContext context) {
    switch (error.code) {
      case 'invalid-email':
        return context.tr('error_invalid_email');
      case 'user-disabled':
        return context.tr('error_user_disabled');
      case 'user-not-found':
        return context.tr('error_user_not_found');
      case 'wrong-password':
        return context.tr('error_wrong_password');
      case 'email-already-in-use':
        return context.tr('error_email_already_in_use');
      case 'operation-not-allowed':
        return context.tr('error_operation_not_allowed');
      case 'weak-password':
        return context.tr('error_weak_password');
      case 'network-request-failed':
        return context.tr('error_network_request_failed');
      case 'too-many-requests':
        return context.tr('error_too_many_requests');
      case 'invalid-credential':
        return context.tr('error_invalid_credential');
      case 'account-exists-with-different-credential':
        return context.tr('error_account_exists_different_credential');
      case 'invalid-verification-code':
        return context.tr('error_invalid_verification_code');
      case 'invalid-verification-id':
        return context.tr('error_invalid_verification_id');
      case 'invalid-action-code':
        return context.tr('error_invalid_action_code');
      case 'invalid-continue-uri':
        return context.tr('error_invalid_continue_uri');
      case 'invalid-dynamic-link-domain':
        return context.tr('error_invalid_dynamic_link_domain');
      default:
        return context.tr('error_general');
    }
  }

  static String handleGeneralError(Exception error, BuildContext context) {
    return context.tr('error_general');
  }

  // Helper method to get localized error message without context
  static String getLocalizedErrorKey(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'error_invalid_email';
      case 'user-disabled':
        return 'error_user_disabled';
      case 'user-not-found':
        return 'error_user_not_found';
      case 'wrong-password':
        return 'error_wrong_password';
      case 'email-already-in-use':
        return 'error_email_already_in_use';
      case 'operation-not-allowed':
        return 'error_operation_not_allowed';
      case 'weak-password':
        return 'error_weak_password';
      case 'network-request-failed':
        return 'error_network_request_failed';
      case 'too-many-requests':
        return 'error_too_many_requests';
      case 'invalid-credential':
        return 'error_invalid_credential';
      case 'account-exists-with-different-credential':
        return 'error_account_exists_different_credential';
      case 'invalid-verification-code':
        return 'error_invalid_verification_code';
      case 'invalid-verification-id':
        return 'error_invalid_verification_id';
      case 'invalid-action-code':
        return 'error_invalid_action_code';
      case 'invalid-continue-uri':
        return 'error_invalid_continue_uri';
      case 'invalid-dynamic-link-domain':
        return 'error_invalid_dynamic_link_domain';
      default:
        return 'error_general';
    }
  }
}
