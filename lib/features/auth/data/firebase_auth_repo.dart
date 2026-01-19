import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> logInWithEmailPassword(String email, String password) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) {
    // TODO: implement registerWithEmailPassword
    throw UnimplementedError();
  }
}
