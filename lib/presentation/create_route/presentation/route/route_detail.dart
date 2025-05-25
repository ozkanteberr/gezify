import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/widgets/destination_mini_card.dart';
import 'package:gezify/presentation/destination/bloc/destination_bloc.dart';
import 'package:gezify/presentation/destination/bloc/destination_state.dart';
import 'package:gezify/presentation/destination/bloc/destination_event.dart';

class DestinationMiniListPage extends StatelessWidget {
  const DestinationMiniListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DestinationBloc(firestore: FirebaseFirestore.instance)
        ..add(LoadDestinations()),
      child: Scaffold(
        backgroundColor: Color(0xFFE8F5F2),
        appBar: AppBar(
          title: const Text('Popüler Rotalar'),
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: const Color(0xFFE8F5F2),
        ),
        body: BlocBuilder<DestinationBloc, DestinationState>(
          builder: (context, state) {
            if (state is DestinationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DestinationLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 4, // Resme göre oran
                ),
                itemCount: state.destinations.length,
                itemBuilder: (context, index) {
                  final destination = state.destinations[index];
                  return DestinationMiniCard(destination: destination);
                },
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
