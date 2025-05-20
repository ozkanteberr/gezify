abstract class MyRoutesEvent {}

class FetchMyRoutes extends MyRoutesEvent {}

class DeleteRoute extends MyRoutesEvent {
  final String routeId;

  DeleteRoute(this.routeId);
}
