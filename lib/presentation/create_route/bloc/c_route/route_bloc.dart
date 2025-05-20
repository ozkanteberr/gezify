import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'route_event.dart';
import 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(RouteState([])) {
    on<AddDestinationToRoute>((event, emit) {
      final newRoutes = List<Destination>.from(state.routes)
        ..add(event.destination);
      emit(state.copyWith(routes: newRoutes));
    });

    on<RemoveDestinationFromRoute>((event, emit) {
      final newRoutes = List<Destination>.from(state.routes)
        ..removeAt(event.index);
      emit(state.copyWith(routes: newRoutes));
    });

    on<TogglePrivacy>((event, emit) {
      emit(state.copyWith(isPrivate: event.isPrivate));
    });

    on<ClearDestinations>((event, emit) {
      emit(RouteState([], isPrivate: state.isPrivate));
    });

    on<SaveDestinationsToFirebase>((event, emit) async {
      try {
        final firestore = FirebaseFirestore.instance;
        final routeDoc = firestore.collection('userRoutes').doc(event.uid);
        final routeLists = routeDoc.collection('routeLists');

        final destinationsMap = state.routes
            .map((destination) => {
                  'title': destination.title,
                  'latitude': destination.latitude,
                  'longitude': destination.longitude,
                })
            .toList();

        await routeLists.add({
          'title': event.listTitle,
          'isPrivate': state.isPrivate,
          'createdAt': FieldValue.serverTimestamp(),
          'routes': destinationsMap,
        });
      } catch (e) {
        print("Firebase'e kaydetme hatası: $e");
      }
    });
  }
}
