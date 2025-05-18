import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCommentService {
  static Future<void> submitComment({
    required String destinationId,
    required String commentText,
    required String userName,
  }) async {
    final comment = {
      'user': userName,
      'text': commentText,
      'timestamp': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('destinations')
        .doc(destinationId)
        .collection('comments')
        .add(comment);
  }
}
