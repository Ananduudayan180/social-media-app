import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser({
    required super.email,
    required super.name,
    required super.uid,
    required this.bio,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
  });

  //method to update profile user

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newfollowers,
    List<String>? newfollowing,
  }) {
    return ProfileUser(
      email: email,
      name: name,
      uid: uid,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: newfollowers ?? followers,
      following: newfollowing ?? following,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      email: json['email'],
      name: json['name'],
      uid: json['uid'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
