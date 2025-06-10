import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/services/zegoCloud_call.dart';
import 'package:sign_wave_v3/features/auth/data/repositories/auth_repository.dart';

import 'auth_state.dart';

import '../../../../core/services/di.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  StreamSubscription<User?>? _authStateSubscription;

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
          emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
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
            error: "Please verify your email first. Verification email sent.",
          ),
        );
        return;
      }

      final user = await _authRepository.getUserData(userCredential.uid);
      //await onUserLogin(user.uid, user.fullName);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
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
      await onUserLogin(user.uid, user.fullName);
      emit(state.copyWith(status: AuthStatus.emailUnverified, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      print(getIt<AuthRepository>().currentUser?.uid ?? "asasa");
      onUserLogout();
      await _authRepository.signOut();
      print(getIt<AuthRepository>().currentUser?.uid ?? "asasa");
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);

      emit(state.copyWith(status: AuthStatus.passwordResetEmailSent));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }
}
