import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo extends ProfileRepo {
  final CollectionReference firestore = FirebaseFirestore.instance.collection(
    'users',
  );

  @override
  Future<ProfileUser?> fetchUser(String uid) async {
    try {
      final userDoc = await firestore.doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          return ProfileUser(
            email: userData['email'],
            name: userData['name'],
            uid: uid,
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      await firestore.doc(updatedProfile.uid).update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
