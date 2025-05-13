import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/spotify/cubits/spotify_cubit.dart';
import 'package:gezify/presentation/spotify/cubits/spotify_state.dart';


class SpotifyControls extends StatelessWidget {
  const SpotifyControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpotifyCubit, SpotifyState>(
      listener: (context, state) {
        if (state is SpotifyError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      builder: (context, state) {
        if (state is SpotifyConnecting) {
          return const CircularProgressIndicator();
        }
        if (state is SpotifyConnected || state is SpotifyPlaying) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<SpotifyCubit>().playTrack(
                        'spotify:track:4uLU6hMCjMI75M1A2tKUQC',
                      );
                },
                child: const Text('Şarkıyı Çal'),
              ),
            ],
          );
        }

        return ElevatedButton(
          onPressed: () {
            context.read<SpotifyCubit>().connectToSpotify();
          },
          child: const Text('Spotify\'a Bağlan'),
        );
      },
    );
  }
}
