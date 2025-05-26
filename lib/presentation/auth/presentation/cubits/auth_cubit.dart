import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/auth/domain/entities/app_user.dart';
import 'package:gezify/presentation/auth/domain/repos/auth_repo.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  void checkUser() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authanticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await authRepo.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authanticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated(errorMessage: e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      emit(AuthLoading());

      final user =
          await authRepo.registerWithEmailPassword(email, password, name);

      if (user != null) {
        _currentUser = user;
        emit(Authanticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated(errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(AuthLoading());

      final user = await authRepo.loginWithGoogle();

      if (user != null) {
        _currentUser = user;
        emit(Authanticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }
}
