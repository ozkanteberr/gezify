import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gezify/presentation/create_route/data/route_model.dart';

import 'my_routes_event.dart';
import 'my_route_state.dart';

class MyRoutesBloc extends Bloc<MyRoutesEvent, MyRoutesState> {
  MyRoutesBloc() : super(MyRoutesLoading()) {
    on<FetchMyRoutes>(_onFetchMyRoutes);
    on<DeleteRoute>(_onDeleteRoute);
  }

  Future<void> _onFetchMyRoutes(
      FetchMyRoutes event, Emitter<MyRoutesState> emit) async {
    emit(MyRoutesLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı oturumu açık değil.");

      final snapshot = await FirebaseFirestore.instance
          .collection('userRoutes')
          .doc(user.uid)
          .collection('routeLists')
          .get();

      final routeLists = snapshot.docs.map((doc) {
        return RouteList.fromMap(doc.data());
      }).toList();

      emit(MyRoutesLoaded(routeLists));
    } catch (e) {
      emit(MyRoutesError("Rotalar yüklenemedi: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteRoute(
      DeleteRoute event, Emitter<MyRoutesState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı oturumu açık değil.");

      await FirebaseFirestore.instance
          .collection('userRoutes')
          .doc(user.uid)
          .collection('routeLists')
          .doc(event.routeId)
          .delete();

      add(FetchMyRoutes()); // Silme sonrası tekrar listele
    } catch (e) {
      emit(MyRoutesError("Silme işlemi başarısız: ${e.toString()}"));
    }
  }
}
