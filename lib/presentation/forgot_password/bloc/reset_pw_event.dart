abstract class ForgotPasswordEvent {}

class EmailChanged extends ForgotPasswordEvent {
  final String email;
  EmailChanged(this.email);
}

class SubmitEmail extends ForgotPasswordEvent {}
