import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthCubit authCubit;

  ProfileBloc({required this.authCubit}) : super(ProfileState.initial()) {
    on<LoadProfile>((event, emit) {
      final user = authCubit.currentUser;
      if (user != null) {
        emit(state.copyWith(
          username: user.name,
          subtitle: user.email,
        ));
      } else {
        emit(state); // kullanıcı yoksa mevcut state'i gönder
      }
    });

    on<OptionTapped>((event, emit) {
      print("Tapped option: ${event.option}");
    });
  }
}
