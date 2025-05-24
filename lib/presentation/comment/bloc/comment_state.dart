import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String userName;
  final String comment;

  const Comment({required this.userName, required this.comment});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userName: map['userName'] ?? '',
      comment: map['comment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'comment': comment,
    };
  }

  @override
  List<Object?> get props => [userName, comment];
}

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;

  const CommentLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}
