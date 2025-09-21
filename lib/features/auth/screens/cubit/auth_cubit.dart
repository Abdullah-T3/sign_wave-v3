import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/features/auth/data/repositories/auth_repository.dart';
import 'package:sign_wave_v3/features/auth/data/models/user_model.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  // ignore: unused_field
  StreamSubscription<User?>? _authStateSubscription;

  /// Helper method to extract error message from exceptions
  String _extractErrorMessage(dynamic error) {
    final errorString = error.toString();
    log('DEBUG: Original error: $errorString');
    // Remove "Exception: " prefix if present
    if (errorString.startsWith('Exception: ')) {
      final extracted = errorString.substring(
        11,
      ); // Remove "Exception: " (11 characters)
      log('DEBUG: Extracted error: $extracted');
      return extracted;
    }
    log('DEBUG: Using original error: $errorString');
    return errorString;
  }

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _init();
  }

  void _init() {
    emit(state.copyWith(status: AuthStatus.initial));

    _authStateSubscription = _authRepository.authStateChanges.listen((
      user,
    ) async {
      if (user != null && user.emailVerified) {
        try {
          final userData = await _authRepository.getUserData(user.uid);
          emit(
            state.copyWith(status: AuthStatus.authenticated, user: userData),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: AuthStatus.error,
              error: _extractErrorMessage(e),
            ),
          );
        }
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final userCredential = await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!userCredential.emailVerified) {
        await userCredential.sendEmailVerification();
        emit(
          state.copyWith(
            status: AuthStatus.emailUnverified,
            error: "error_email_not_verified",
          ),
        );
        return;
      }

      log('DEBUG: Getting user data for UID: ${userCredential.uid}');
      try {
        final user = await _authRepository.getUserData(userCredential.uid);
        log('DEBUG: User data retrieved successfully: ${user.fullName}');
        //await onUserLogin(user.uid, user.fullName);
        log('DEBUG: Emitting authenticated state');
        final newState = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
        emit(newState);
        log('DEBUG: ✅ State emitted successfully - Status: ${newState.status}');
      } catch (e) {
        log(
          'DEBUG: getUserData failed, creating temporary user: ${e.toString()}',
        );
        // Create a temporary user model if Firestore document doesn't exist
        final tempUser = UserModel(
          uid: userCredential.uid,
          username: userCredential.email?.split('@')[0] ?? 'user',
          fullName: userCredential.displayName ?? 'User',
          email: userCredential.email ?? '',
          phoneNumber: '',
        );
        log('DEBUG: Emitting authenticated state with temp user');
        final newState = state.copyWith(
          status: AuthStatus.authenticated,
          user: tempUser,
        );
        emit(newState);
        log(
          'DEBUG: ✅ Temp user state emitted successfully - Status: ${newState.status}',
        );
      }
    } catch (e) {
      log('DEBUG: SignIn error: ${e.toString()}');
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _extractErrorMessage(e),
        ),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final user = await _authRepository.signUp(
        fullName: fullName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      // await onUserLogin(user.uid, user.fullName);
      emit(state.copyWith(status: AuthStatus.emailUnverified, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _extractErrorMessage(e),
        ),
      );
    }
  }

  Future<void> signOut() async {
    try {
      // onUserLogout();
      await _authRepository.signOut();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _extractErrorMessage(e),
        ),
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);

      emit(state.copyWith(status: AuthStatus.passwordResetEmailSent));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _extractErrorMessage(e),
        ),
      );
    }
  }
}
