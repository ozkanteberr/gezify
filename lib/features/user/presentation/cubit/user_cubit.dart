import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/features/user/domain/entities/app_user.dart';
import 'package:gezify/features/user/domain/usecases/get_current_user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUser getCurrentUserUseCase;

  UserCubit(this.getCurrentUserUseCase) : super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());
    final user = await getCurrentUserUseCase();
    if (user != null) {
      emit(UserLoaded(user));
    } else {
      emit(UserError("Kullanıcı bulunamadı."));
    }
  }
}
