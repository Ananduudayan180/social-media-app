import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> logInWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );
  Future<void> logOut();
  Future<AppUser?> getCurrentUser();
}
