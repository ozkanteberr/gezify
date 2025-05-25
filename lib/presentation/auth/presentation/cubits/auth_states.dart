import 'package:gezify/presentation/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authanticated extends AuthStates {
  final AppUser user;
  Authanticated(this.user);
}

class Unauthenticated extends AuthStates {
  final String? errorMessage;
  Unauthenticated({this.errorMessage});
}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}
