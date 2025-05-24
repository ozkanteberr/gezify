abstract class SaveRouteState {
  const SaveRouteState();
}

class SaveRouteInitial extends SaveRouteState {}

class SaveRouteLoading extends SaveRouteState {}

class SavedRoutesLoaded extends SaveRouteState {
  final List<Map<String, dynamic>> savedRoutes;

  SavedRoutesLoaded(this.savedRoutes);
}

class SaveRouteFailure extends SaveRouteState {
  final String message;

  const SaveRouteFailure(this.message);
}
