import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_event.dart';
import 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  int _counter = 1;

  RouteBloc() : super(RouteState([])) {
    on<AddRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes)..add('Rota $_counter');
      _counter++;
      emit(RouteState(newRoutes));
    });

    on<RemoveRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes)..removeAt(event.index);
      emit(RouteState(newRoutes));
    });

    on<EditRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes);
      newRoutes[event.index] = event.newName;
      emit(RouteState(newRoutes));
    });

    on<ReorderRoute>((event, emit) {
      final newRoutes = List<String>.from(state.routes);
      int adjustedNewIndex = event.newIndex;
      if (event.newIndex > event.oldIndex) {
        adjustedNewIndex--;
      }
      final item = newRoutes.removeAt(event.oldIndex);
      newRoutes.insert(adjustedNewIndex, item);
      emit(RouteState(newRoutes));
    });

    on<SaveRoutes>((event, emit) {
      // Veritabanına veya shared_preferences'a kaydedilebilir.
      print("Kaydedilen Rotalar: ${state.routes}");
    });
  }
}
