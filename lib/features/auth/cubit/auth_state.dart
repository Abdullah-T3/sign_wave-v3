import 'package:equatable/equatable.dart';

import '../data/models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailUnverified,
  error,
  passwordResetEmailSent,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final bool? isEmailVerified;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isEmailVerified = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
    bool? isEmailVerified,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [status, user, error, isEmailVerified];
}
