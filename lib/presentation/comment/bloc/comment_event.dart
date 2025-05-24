import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class LoadComments extends CommentEvent {
  final String destinationId;

  const LoadComments({required this.destinationId});

  @override
  List<Object?> get props => [destinationId];
}

class AddComment extends CommentEvent {
  final String destinationId;
  final String userName;
  final String comment;

  const AddComment({
    required this.destinationId,
    required this.userName,
    required this.comment,
  });

  @override
  List<Object?> get props => [destinationId, userName, comment];
}
