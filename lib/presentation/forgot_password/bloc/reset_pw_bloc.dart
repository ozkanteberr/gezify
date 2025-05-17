import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reset_pw_event.dart';
import 'reset_pw_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordState.initial()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(
          email: event.email, isFailure: false, isSuccess: false));
    });

    on<SubmitEmail>((event, emit) async {
      emit(state.copyWith(
          isSubmitting: true, isFailure: false, isSuccess: false));
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: state.email.trim());
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, isFailure: true));
      }
    });
  }
}
