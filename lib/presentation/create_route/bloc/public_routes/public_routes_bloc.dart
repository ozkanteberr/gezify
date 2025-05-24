import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/public_routes/public_routes_event.dart';
import 'package:gezify/presentation/create_route/bloc/public_routes/public_routes_state.dart';

class PublicRouteBloc extends Bloc<PublicRouteEvent, PublicRouteState> {
  final FirebaseFirestore firestore;
  StreamSubscription<QuerySnapshot>? _subscription;

  PublicRouteBloc({required this.firestore}) : super(PublicRouteLoading()) {
    on<LoadPublicRoutes>(_onLoadPublicRoutes);
    on<PublicRouteUpdated>(_onPublicRouteUpdated);
  }

  Future<void> _onLoadPublicRoutes(
    LoadPublicRoutes event,
    Emitter<PublicRouteState> emit,
  ) async {
    emit(PublicRouteLoading());

    await _subscription?.cancel();

    _subscription =
        firestore.collection('publicUserRoutes').snapshots().listen((snapshot) {
      add(PublicRouteUpdated(snapshot.docs));
    });
  }

  void _onPublicRouteUpdated(
    PublicRouteUpdated event,
    Emitter<PublicRouteState> emit,
  ) {
    final publicRoutes = event.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();

    emit(PublicRouteLoaded(publicRoutes));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
