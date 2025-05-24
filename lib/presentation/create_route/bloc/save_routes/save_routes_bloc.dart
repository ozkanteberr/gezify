import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_event.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_state.dart';

class SaveRouteBloc extends Bloc<SaveRouteEvent, SaveRouteState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  StreamSubscription? _savedRoutesSubscription;

  SaveRouteBloc({required this.firestore, required this.auth})
      : super(SaveRouteInitial()) {
    on<LoadSavedRoutes>(_onLoadSavedRoutes);
    on<ToggleSaveRouteRequested>(_onToggleSaveRouteRequested);
    on<SavedRoutesUpdated>(_onSavedRoutesUpdated);
  }

  Future<void> _onLoadSavedRoutes(
      LoadSavedRoutes event, Emitter<SaveRouteState> emit) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(const SaveRouteFailure('Kullanıcı giriş yapmamış.'));
      return;
    }

    emit(SaveRouteLoading());

    await _savedRoutesSubscription?.cancel();

    _savedRoutesSubscription = firestore
        .collection('userRoutes')
        .doc(user.uid)
        .collection('saveRoutes')
        .snapshots()
        .listen((snapshot) {
      final savedRoutesData = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'isPrivate': data['isPrivate'] ?? true,
          'routes': data['routes'] ?? [],
        };
      }).toList();

      add(SavedRoutesUpdated(savedRoutesData));
    }, onError: (error) {
      emit(SaveRouteFailure(error.toString()));
    });
  }

  void _onSavedRoutesUpdated(
      SavedRoutesUpdated event, Emitter<SaveRouteState> emit) {
    emit(SavedRoutesLoaded(event.savedRoutes));
  }

  Future<void> _onToggleSaveRouteRequested(
      ToggleSaveRouteRequested event, Emitter<SaveRouteState> emit) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(const SaveRouteFailure('Kullanıcı giriş yapmamış.'));
      return;
    }

    final docRef = firestore
        .collection('userRoutes')
        .doc(user.uid)
        .collection('saveRoutes')
        .doc(event.route.id);

    try {
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Eğer kayıtlıysa sil
        await docRef.delete();
      } else {
        // Değilse ekle
        await docRef.set({
          'title': event.route.title,
          'isPrivate': event.route.isPrivate,
          'routes': event.route.routes,
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      emit(SaveRouteFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _savedRoutesSubscription?.cancel();
    return super.close();
  }
}
