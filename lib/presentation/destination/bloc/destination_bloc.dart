import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/destination/bloc/destination_event.dart';
import 'package:gezify/presentation/destination/bloc/destination_state.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  final FirebaseFirestore firestore;

  DestinationBloc({required this.firestore}) : super(DestinationLoading()) {
    on<LoadDestinations>((event, emit) async {
      emit(DestinationLoading());

      try {
        final snapshot = await firestore.collection('destination').get();

        final destinations = snapshot.docs.map((doc) {
          final data = doc.data();
          return Destination(
            title: data['title'],
            adress: data['adress'],
            id: data['id'],
            bannerImage: data['bannerImage'],
            description: data['description'] ,
            categoryList: List<String>.from(data['categoryList'] ?? []),
            isBestDestination: data['isBestDestination'] ?? false,
            images: List<String>.from(data['detailImages'] ?? []),
            latitude: data['latitude'],
            longitude: data['longitude'],
            rating: (data['rating'] ?? 0).toDouble(),
          );
        }).toList();

        emit(DestinationLoaded(destinations));
      } catch (e) {
        emit(DestinationError('Veriler yüklenemedi'));
      }
    });
  }
}
