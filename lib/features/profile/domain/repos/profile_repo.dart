import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUser(String uid);
  Future<void> updateProfile(ProfileUser updatedProfile);
}
