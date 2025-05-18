import 'package:gezify/domain/entities/comment.dart';


import '../repositories/comment_repository.dart';

class AddComment {
  final CommentRepository repository;

  AddComment(this.repository);

  Future<void> call(Comment comment) => repository.addComment(comment);
}
