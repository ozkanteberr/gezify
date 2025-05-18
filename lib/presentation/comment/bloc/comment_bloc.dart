import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/domain/entities/usecases/add_comment.dart';
import 'package:gezify/domain/entities/usecases/get_comments.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final AddComment addComment;
  final GetComments getComments;

  CommentBloc({
    required this.addComment,
    required this.getComments,
  }) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddNewComment>(_onAddNewComment);
  }

  Future<void> _onLoadComments(LoadComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final comments = await getComments(event.destinationId);
      // emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Yorumlar yüklenemedi.'));
    }
  }

  Future<void> _onAddNewComment(AddNewComment event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final currentState = state as CommentLoaded;
      try {
        await addComment(event.comment);
        final updatedList = [event.comment, ...currentState.comments];
        emit(CommentLoaded(updatedList));
      } catch (_) {
        emit(CommentError("Yorum eklenemedi."));
      }
    }
  }
}
