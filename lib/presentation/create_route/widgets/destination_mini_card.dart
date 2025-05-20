import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/destination/pages/destination_detail_page.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:gezify/presentation/home/presentation/cubits/destination/destination_cubit.dart';
import 'package:gezify/presentation/maps/pages/map_screen.dart';

class DestinationMiniCard extends StatelessWidget {
  final Destination destination;

  const DestinationMiniCard({Key? key, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DestinationDetailPage(destination: destination),
          ),
        );
      },
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  destination.bannerImage.isNotEmpty
                      ? Image.network(
                          destination.bannerImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 170,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Icon(Icons.broken_image, size: 40));
                          },
                        )
                      : const Center(
                          child: Icon(Icons.image_not_supported, size: 40)),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<DestinationCubit>()
                                  .selectDestination(destination);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GoogleMapScreen(destination: destination),
                                ),
                              );
                            },
                            child: const Icon(Icons.location_on,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<RouteBloc>()
                                  .add(AddDestinationToRoute(destination));
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                destination.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                destination.adress,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
