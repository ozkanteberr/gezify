abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class OptionTapped extends ProfileEvent {
  final String option;

  OptionTapped(this.option);
}
