abstract class SpotifyState {}

class SpotifyInitial extends SpotifyState {}

class SpotifyConnecting extends SpotifyState {}

class SpotifyConnected extends SpotifyState {}

class SpotifyPlaying extends SpotifyState {
  final String trackUri;
  SpotifyPlaying(this.trackUri);
}

class SpotifyError extends SpotifyState {
  final String message;
  SpotifyError(this.message);
}
