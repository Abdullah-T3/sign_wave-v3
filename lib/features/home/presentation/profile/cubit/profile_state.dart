import 'package:equatable/equatable.dart';
import 'package:sign_wave_v3/features/auth/data/models/user_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  editing,
  updating,
  error,
  updated,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel? user;
  final String? error;
  final bool isEditing;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.error,
    this.isEditing = false,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? error,
    bool? isEditing,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [status, user, error, isEditing];
}
