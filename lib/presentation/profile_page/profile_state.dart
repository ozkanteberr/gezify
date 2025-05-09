class ProfileState {
  final String username;
  final String subtitle;
  final List<String> options;

  ProfileState({
    required this.username,
    required this.subtitle,
    required this.options,
  });

  factory ProfileState.initial() {
    return ProfileState(
      username: "Cagatay",
      subtitle: "Gezify üyesi",
      options: ["Profil", "Payment", "Settings", "FAQ"],
    );
  }
}
