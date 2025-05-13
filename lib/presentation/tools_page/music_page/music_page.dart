import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final String clientId = 'fe7c57ff33d4426da4460b57c3686dcc';
  final String clientSecret = '11b921b25e8d4786a83cd3bbb8cecec6';
  final String playlistId = '74kSjyWv8NbFBvmOjAy2u1';
  String accessToken = '';
  List<PlaylistTrack> tracks = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      accessToken = jsonDecode(response.body)['access_token'];
      _fetchPlaylistTracks();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Token alınamadı: ${response.statusCode}';
      });
    }
  }

  Future<void> _fetchPlaylistTracks() async {
    final url = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List;

        setState(() {
          tracks = items.map((item) => PlaylistTrack.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Şarkılar alınamadı: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Hata oluştu: $e';
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Spotify bağlantısı açılamadı: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Seyahat Müzikleri'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            track.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(track.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(track.artist, style: const TextStyle(color: Colors.grey)),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Colors.green),
                          onPressed: () => _launchURL(track.url),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class PlaylistTrack {
  final String name;
  final String artist;
  final String imageUrl;
  final String url;

  PlaylistTrack({
    required this.name,
    required this.artist,
    required this.imageUrl,
    required this.url,
  });

  factory PlaylistTrack.fromJson(Map<String, dynamic> json) {
    final track = json['track'];
    return PlaylistTrack(
      name: track['name'],
      artist: (track['artists'] as List).map((a) => a['name']).join(', '),
      imageUrl: track['album']['images'][0]['url'],
      url: track['external_urls']['spotify'],
    );
  }
}
