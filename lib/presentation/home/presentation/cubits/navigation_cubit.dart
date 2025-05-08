import 'package:flutter_bloc/flutter_bloc.dart';

// Navigation states
abstract class NavigationState {
  final int index;
  const NavigationState(this.index);
}

class NavigationInitial extends NavigationState {
  const NavigationInitial() : super(0);
}

class NavigationChanged extends NavigationState {
  const NavigationChanged(int index) : super(index);
}

// Navigation cubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationInitial());

  void changeIndex(int index) {
    emit(NavigationChanged(index));
  }
}
