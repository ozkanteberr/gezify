import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<LoadProfile>((event, emit) {
      // Gerekirse API'den veri çekilebilir.
      emit(ProfileState.initial());
    });

    on<OptionTapped>((event, emit) {
      // Burada loglama veya yönlendirme işlemleri yapılabilir
      print("Tapped option: ${event.option}");
    });
  }
}
