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
      username: "Kullanıcı", // varsayılan
      subtitle: "Gezify üyesi",
      options: ["Profil", "Seyahat Geçmişi", "Settings", "FAQ", "Çıkış Yap"],
    );
  }

  ProfileState copyWith({
    String? username,
    String? subtitle,
    List<String>? options,
  }) {
    return ProfileState(
      username: username ?? this.username,
      subtitle: subtitle ?? this.subtitle,
      options: options ?? this.options,
    );
  }
}
