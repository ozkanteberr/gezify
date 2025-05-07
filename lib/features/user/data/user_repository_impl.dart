import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/features/user/domain/entities/app_user.dart';
import 'package:gezify/features/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore;

  UserRepositoryImpl(this.firestore);

  @override
  Future<AppUsers?> getCurrentUser() async {
    final uid = "firebase_user_id"; // FirebaseAuth.instance.currentUser?.uid;
    final doc = await firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      return AppUsers(uid: uid, name: data['name']);
    } else {
      return null;
    }
  }
}
