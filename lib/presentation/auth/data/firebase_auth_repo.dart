import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gezify/presentation/auth/domain/entities/app_user.dart';
import 'package:gezify/presentation/auth/domain/repos/auth_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
    await googleSignIn.signOut();
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

  @override
  Future<void> logoutGoogle() async {
    await firebaseAuth.signOut();
    // Google oturumu kapat
  }

  @override
  Future<AppUser?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Kullanıcı iptal etti
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) return null;

      // Firestore'da kullanıcı varsa getir, yoksa yeni oluştur
      final userDoc = await firebaseFirestore
          .collection("users")
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        // Firestore'a kullanıcı kaydı oluştur
        final newUser = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? '',
        );

        await firebaseFirestore
            .collection("users")
            .doc(newUser.uid)
            .set(newUser.toJson());

        return newUser;
      } else {
        final userData = userDoc.data()!;
        return AppUser.fromJson(userData);
      }
    } catch (e) {
      throw Exception("Google ile giriş yapılamadı! Hata: $e");
    }
  }

  Stream<User?> get currentUserStream {
    return firebaseAuth.authStateChanges();
  }
}
