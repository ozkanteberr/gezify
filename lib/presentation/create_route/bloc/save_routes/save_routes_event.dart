import 'package:gezify/presentation/create_route/data/route_model.dart';

abstract class SaveRouteEvent {
  const SaveRouteEvent();

  List<Object?> get props => [];
}

class LoadSavedRoutes extends SaveRouteEvent {}

class ToggleSaveRouteRequested extends SaveRouteEvent {
  final RouteList route;

  ToggleSaveRouteRequested(this.route);

  @override
  List<Object?> get props => [route];
}

class SavedRoutesUpdated extends SaveRouteEvent {
  final List<Map<String, dynamic>> savedRoutes;

  SavedRoutesUpdated(this.savedRoutes);

  @override
  List<Object?> get props => [savedRoutes];
}
