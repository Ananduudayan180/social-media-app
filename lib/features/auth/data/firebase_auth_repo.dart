import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = AppUser(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );
      // save user data in firestore
      await firestore.collection('users').doc(user.uid).set(user.toJson());
      return user;
    } catch (e) {
      throw Exception('Signup failed $e');
    }
  }

  @override
  Future<AppUser?> logInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // get user data
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final user = AppUser(
        uid: userCredential.user!.uid,
        name: userDoc['name'],
        email: email,
      );
      return user;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    //get user data
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      return null;
    }
    return AppUser(
      uid: firebaseUser.uid,
      name: userDoc['name'],
      email: firebaseUser.email!,
    );
  }
}
