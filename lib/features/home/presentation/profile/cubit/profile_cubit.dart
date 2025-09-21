import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/features/auth/data/models/user_model.dart';
import 'package:sign_wave_v3/features/auth/data/repositories/auth_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ProfileState());

  Future<void> loadUserData() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        final userData = await _authRepository.getUserData(currentUser.uid);
        emit(state.copyWith(status: ProfileStatus.loaded, user: userData));
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            error: 'User not logged in',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  void toggleEditMode() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }

  Future<void> updateProfile(
    UserModel updatedUser,
    DeviceInfo deviceInfo,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await _authRepository.updateUserData(updatedUser);
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: updatedUser,
          isEditing: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      emit(state.copyWith(status: ProfileStatus.updating));
      await _authRepository.saveUserData(user);
      emit(state.copyWith(status: ProfileStatus.loaded, user: user));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(state.copyWith(status: ProfileStatus.updating));
      await _authRepository.deleteAccount();
      emit(state.copyWith(status: ProfileStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }
}
