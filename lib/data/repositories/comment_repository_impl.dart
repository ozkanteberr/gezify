import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/domain/entities/repositories/comment_repository.dart';
import '../../domain/entities/comment.dart';


class CommentRepositoryImpl implements CommentRepository {
  final FirebaseFirestore firestore;

  CommentRepositoryImpl(this.firestore);

  @override
  Future<void> addComment(Comment comment) async {
    await firestore.collection('comments').add(comment.toMap());
  }

  @override
  Stream<List<Comment>> getComments(String destinationId) {
    return firestore
        .collection('comments')
        .where('destinationId', isEqualTo: destinationId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromMap(doc.data(), doc.id))
            .toList());
  }
}
