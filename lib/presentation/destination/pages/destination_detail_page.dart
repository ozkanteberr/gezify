import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:gezify/presentation/maps/pages/map_screen.dart';

class DestinationDetailPage extends StatefulWidget {
  final Destination destination;

  const DestinationDetailPage({Key? key, required this.destination})
      : super(key: key);

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Görsel Kartı
            Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: Image.network(
                destination.bannerImage,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Detaylar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.title,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red[400]),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          destination.adress,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 6),
                      Text(
                        '${destination.rating}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Haritada Göster ve Rotama Ekle Butonları
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GoogleMapScreen(destination: destination),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.map,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Haritada Göster',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context
                                .read<RouteBloc>()
                                .add(AddDestinationToRoute(destination));
                          },
                          icon: Icon(
                            Icons.add_location_alt,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Rotama Ekle',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Galeri
                  Text(
                    "Fotoğraflar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.85),
                      children: [
                        _buildGalleryImage(destination.bannerImage),
                        _buildGalleryImage('https://picsum.photos/500?1'),
                        _buildGalleryImage('https://picsum.photos/500?2'),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Yorumlar
                  Text(
                    "Yorumlar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildReview(
                      "Mekan çok güzel, özellikle uçak teması çocuklar için harika!",
                      "Ahmet K."),
                  _buildReview(
                      "Pidesi çok lezzetliydi, çalışanlar da çok güler yüzlü.",
                      "Elif D."),
                  _buildReview(
                      "Gece ışıklandırması etkileyici, tekrar geleceğim.",
                      "Murat B."),
                  SizedBox(height: 20),
                  Divider(),

                  // Yorum Yapma Alanı
                  Text(
                    "Yorum Yap",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Yorumunuzu yazın...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final comment = _commentController.text.trim();
                        if (comment.isNotEmpty) {
                          print(
                              "Yeni yorum: $comment"); // Burada backend'e gönderilebilir
                          _commentController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Yorum gönderildi!")),
                          );
                        }
                      },
                      icon: Icon(Icons.send),
                      label: Text("Gönder"),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildReview(String comment, String user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person, size: 32, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(comment),
              ],
            ),
          )
        ],
      ),
    );
  }
}
