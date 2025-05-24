import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/comment/data/comment_repo.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  CommentBloc({required this.commentRepository}) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
  }

  Future<void> _onLoadComments(
      LoadComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final comments = await commentRepository.getComments(event.destinationId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Yorumlar yüklenemedi: ${e.toString()}'));
    }
  }

  Future<void> _onAddComment(
      AddComment event, Emitter<CommentState> emit) async {
    try {
      await commentRepository.addComment(
        event.destinationId,
        event.userName,
        event.comment,
      );
      add(LoadComments(destinationId: event.destinationId)); // refresh
    } catch (e) {
      emit(CommentError('Yorum eklenemedi: ${e.toString()}'));
    }
  }
}
