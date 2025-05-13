import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'spotify_state.dart';

class SpotifyCubit extends Cubit<SpotifyState> {
  SpotifyCubit() : super(SpotifyInitial());

  Future<void> connectToSpotify() async {
    emit(SpotifyConnecting());
    try {
      final result = await SpotifySdk.connectToSpotifyRemote(
        clientId: 'fe7c57ff33d4426da4460b57c3686dcc',
        redirectUrl: 'gezify://callback',
        scope: 'app-remote-control,user-modify-playback-state',
      );
      if (result) {
        emit(SpotifyConnected());
      } else {
        emit(SpotifyError('Bağlantı başarısız'));
      }
    } catch (e) {
      emit(SpotifyError('Hata Detayı: ${e is PlatformException ? e.message : e.toString()}'));
    }
  }

  Future<void> playTrack(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      emit(SpotifyPlaying(uri));
    } catch (e) {
      emit(SpotifyError('Çalma hatası: $e'));
    }
  }
}
