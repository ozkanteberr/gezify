import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/features/user/domain/usecases/get_current_user.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/comment/bloc/comment_bloc.dart';
import 'package:gezify/presentation/comment/bloc/comment_event.dart';
import 'package:gezify/presentation/comment/bloc/comment_state.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:gezify/presentation/maps/pages/map_screen.dart';

class DestinationDetailPage extends StatefulWidget {
  final Destination destination;
  DestinationDetailPage({Key? key, required this.destination})
      : super(key: key);

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final destinationId = widget.destination.id;
    context.read<CommentBloc>().add(LoadComments(destinationId: destinationId));
  }

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
            // Banner Görseli
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

                  // Haritada Göster & Rotama Ekle
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
                          icon: Icon(Icons.map, color: Colors.white),
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
                          icon:
                              Icon(Icons.add_location_alt, color: Colors.white),
                          label: Text(
                            'Rotama Ekle',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Galeri - Yatay kayan şekilde
                  Text(
                    "Fotoğraflar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(right: 16),
                      itemCount: destination.images.length,
                      separatorBuilder: (context, index) => SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                          child: _buildGalleryImage(destination.images[index]),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30),

                  // Yorumlar
                  Text(
                    "Yorumlar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is CommentLoaded) {
                        if (state.comments.isEmpty) {
                          return Text("Henüz yorum yok.");
                        }
                        return Column(
                          children: state.comments
                              .map((comment) => _buildReview(
                                  comment.comment, comment.userName))
                              .toList(),
                        );
                      } else if (state is CommentError) {
                        return Text("Yorumlar yüklenemedi: ${state.message}");
                      }
                      return SizedBox();
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(),

                  // Yorum Yap
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
                        final currentUser =
                            context.read<AuthCubit>().currentUser;
                        if (comment.isNotEmpty) {
                          context.read<CommentBloc>().add(
                                AddComment(
                                  destinationId: widget.destination.id,
                                  userName: currentUser!.name
                                      .toString()
                                      .toUpperCase(),
                                  comment: comment,
                                ),
                              );
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 160,
        width: 240,
        fit: BoxFit.cover,
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
