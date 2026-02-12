import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo extends ProfileRepo {
  final CollectionReference firestore = FirebaseFirestore.instance.collection(
    'users',
  );

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firestore.doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            email: userData['email'],
            name: userData['name'],
            uid: uid,
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
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

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      //get users
      final currentUserDoc = await usersCollection.doc(currentUid).get();
      final targetUserDoc = await usersCollection.doc(targetUid).get();
      //check user doc is extits
      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data() as Map<String, dynamic>?;
        final targetUserData = targetUserDoc.data() as Map<String, dynamic>?;
        //check user data(json) is available or not
        if (currentUserData != null && targetUserData != null) {
          final List<String> currentUserFollowing = List<String>.from(
            currentUserData['following'] ?? [],
          );

          if (currentUserFollowing.contains(targetUid)) {
            //remove from followrs and following list
            await usersCollection.doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid]),
            });
            await usersCollection.doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid]),
            });
          } else {
            //add user in followrs and following list
            await usersCollection.doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid]),
            });
            await usersCollection.doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid]),
            });
          }
        }
      }
    } catch (e) {}
  }
}
