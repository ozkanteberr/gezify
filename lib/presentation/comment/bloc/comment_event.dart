import 'package:gezify/domain/entities/comment.dart';


abstract class CommentEvent {}

class LoadComments extends CommentEvent {
  final String destinationId;
  LoadComments(this.destinationId);
}

class AddNewComment extends CommentEvent {
  final Comment comment;
  AddNewComment(this.comment);
}
