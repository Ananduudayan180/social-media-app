import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepo.fetchUser(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUserProfile({required String uid, String? newBio}) async {
    emit(ProfileLoading());
    try {
      //fetch current user profile first
      final currentUser = await profileRepo.fetchUser(uid);
      if (currentUser == null) {
        emit(ProfileError('Failed to update profile'));
        return;
      }
      //update profile with return instance
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
      );
      //call update user profile
      await profileRepo.updateProfile(updatedProfile);
      //calling updated user(fetch user)
      await profileRepo.fetchUser(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile$e'));
    }
  }
}
