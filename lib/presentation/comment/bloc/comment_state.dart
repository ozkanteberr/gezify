import 'package:gezify/domain/entities/comment.dart';
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;
  CommentLoaded(this.comments);
}

class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}
