import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/presentation/comment/bloc/comment_state.dart';

class CommentRepository {
  final FirebaseFirestore _firestore;

  CommentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Comment>> getComments(String destinationId) async {
    final doc =
        await _firestore.collection('comments').doc(destinationId).get();

    if (doc.exists) {
      final data = doc.data();
      final List<dynamic> rawComments = data?['destinationComments'] ?? [];

      return rawComments
          .map((e) => Comment.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addComment(
      String destinationId, String userName, String comment) async {
    final commentMap = Comment(userName: userName, comment: comment).toMap();
    final docRef = _firestore.collection('comments').doc(destinationId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (snapshot.exists) {
        List<dynamic> existingComments =
            snapshot.data()?['destinationComments'] ?? [];
        existingComments.add(commentMap);
        transaction.update(docRef, {'destinationComments': existingComments});
      } else {
        transaction.set(docRef, {
          'destinationComments': [commentMap],
        });
      }
    });
  }
}
