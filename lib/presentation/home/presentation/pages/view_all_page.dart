import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/destination/pages/destination_detail_page.dart';
import 'package:gezify/presentation/home/data/destination_repository.dart';
import 'package:gezify/presentation/home/presentation/cubits/destination/destination_cubit.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/destination/destination_card.dart';
import 'package:gezify/presentation/maps/pages/map_screen.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({super.key});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DestinationCubit(
        repository:
            DestinationRepository(firestore: FirebaseFirestore.instance),
      )..loadBestDestinations(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tüm Popüler Rotalar"),
          centerTitle: true,
        ),
        body: BlocBuilder<DestinationCubit, DestinationState>(
          builder: (context, state) {
            if (state is DestinationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DestinationLoaded) {
              final destinations = state.allDestinations;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final destination = destinations[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DestinationCard(
                        imageUrl: destination.bannerImage,
                        title: destination.title,
                        location: destination.adress,
                        rating: destination.rating,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DestinationDetailPage(
                                  destination: destination),
                            ),
                          );
                        },
                        onAddToRoutePressed: () {
                          context
                              .read<RouteBloc>()
                              .add(AddDestinationToRoute(destination));
                        },
                        onShowOnMapPressed: () {
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
                      ),
                    );
                  },
                ),
              );
            } else if (state is DestinationError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
