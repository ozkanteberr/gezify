import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gezify/presentation/auth/domain/entities/app_user.dart';
import 'package:gezify/presentation/auth/domain/repos/auth_repo.dart';


class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    // Get user data from Firestore
    final userDoc =
        await firebaseFirestore.collection("users").doc(firebaseUser.uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: userData['name'] ?? '',
      );
    }

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: '');

      return user;
    } catch (e) {
      throw Exception("Giris yapılamadı! Hata:$e");
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception("Kayıt yapılamadı! Hata:$e");
    }
  }

  User? getFirebaseUser() {
    return firebaseAuth.currentUser;
  }

  Stream<User?> get currentUserStream {
    return firebaseAuth.authStateChanges();
  }
}
