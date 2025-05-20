import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_route_state.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_routes_event.dart';
import 'package:gezify/presentation/create_route/data/route_model.dart';

class MyRoutesBloc extends Bloc<MyRoutesEvent, MyRoutesState> {
  MyRoutesBloc() : super(MyRoutesInitial()) {
    on<FetchMyRoutes>((event, emit) async {
      emit(MyRoutesLoading());

      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(MyRoutesError("Kullanıcı oturumu bulunamadı."));
          return;
        }

        final firestore = FirebaseFirestore.instance;
        final snapshot = await firestore
            .collection('userRoutes')
            .doc(user.uid)
            .collection('routeLists')
            .orderBy('createdAt', descending: true)
            .get();

        final routes = snapshot.docs.map((doc) {
          return RotaListesi.fromJson(doc.data());
        }).toList();

        emit(MyRoutesLoaded(routes));
      } catch (e) {
        emit(MyRoutesError('Rotalar yüklenirken hata oluştu: $e'));
      }
    });

    on<DeleteRoute>((event, emit) async {
      try {
        emit(MyRoutesLoading());

        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("Kullanıcı oturumu bulunamadı.");

        final docRef = FirebaseFirestore.instance
            .collection('userRoutes')
            .doc(user.uid)
            .collection('routeLists')
            .doc(event.routeId);

        await docRef.delete();

        // Güncel rotaları tekrar çek
        final querySnapshot = await FirebaseFirestore.instance
            .collection('userRoutes')
            .doc(user.uid)
            .collection('routeLists')
            .orderBy('createdAt', descending: true)
            .get();

        final routes = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return RotaListesi(
            listName: '',
            id: doc.id,
            title: data['title'] ?? '',
            routes: List<String>.from(data['routes'] ?? []),
            isPrivate: data['isPrivate'] ?? true,
          );
        }).toList();

        emit(MyRoutesLoaded(routes));
      } catch (e) {
        emit(MyRoutesError("Silme işlemi başarısız: ${e.toString()}"));
      }
    });
  }
}
