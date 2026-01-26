import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.email,
    required super.name,
    required super.uid,
    required this.bio,
    required this.profileImageUrl,
  });

  //method to update profile user

  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
      email: email,
      name: name,
      uid: uid,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
    );
  }

  @override
  Map<String, String> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      email: json['email'],
      name: json['name'],
      uid: json['uid'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
