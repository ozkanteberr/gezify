import 'package:gezify/domain/entities/comment.dart';



abstract class CommentRepository {
  Future<void> addComment(Comment comment);
  Stream<List<Comment>> getComments(String destinationId);
}
