import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/route_event.dart';
import 'package:gezify/presentation/create_route/bloc/route_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  int _counter = 1;

  RouteBloc() : super(RouteState([])) {
    on<AddRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes)..add('Rota $_counter');
      _counter++;
      emit(state.copyWith(routes: newRoutes));
    });

    on<RemoveRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes)..removeAt(event.index);
      emit(state.copyWith(routes: newRoutes));
    });

    on<EditRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes);
      newRoutes[event.index] = event.newName;
      emit(state.copyWith(routes: newRoutes));
    });

    on<ReorderRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes);
      int adjustedNewIndex =
          event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
      final item = newRoutes.removeAt(event.oldIndex);
      newRoutes.insert(adjustedNewIndex, item);
      emit(state.copyWith(routes: newRoutes));
    });

    on<TogglePrivacy>((event, emit) {
      emit(state.copyWith(isPrivate: event.isPrivate));
    });

    on<SaveRoutesToFirebase>((event, emit) async {
      try {
        final firestore = FirebaseFirestore.instance;
        final routeDoc = firestore.collection('userRoutes').doc(event.uid);
        final routeLists = routeDoc.collection('routeLists');

        await routeLists.add({
          'title': event.listTitle,
          'routes': state.routes,
          'isPrivate': event.isPrivate,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("Rotalar Firebase'e başarıyla kaydedildi.");
      } catch (e) {
        print("Firebase'e kaydetme hatası: $e");
      }
    });

    on<ClearRoutes>((event, emit) {
      emit(RouteState([], isPrivate: state.isPrivate));
    });
  }
}
