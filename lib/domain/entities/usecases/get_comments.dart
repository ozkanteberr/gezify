import 'package:gezify/domain/entities/comment.dart';

import '../repositories/comment_repository.dart';

class GetComments {
  final CommentRepository repository;

  GetComments(this.repository);

  Stream<List<Comment>> call(String destinationId) =>
      repository.getComments(destinationId);
}
