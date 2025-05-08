abstract class RouteEvent {}

class AddRoute extends RouteEvent {}

class RemoveRoute extends RouteEvent {
  final int index;
  RemoveRoute(this.index);
}

class EditRoute extends RouteEvent {
  final int index;
  final String newName;
  EditRoute(this.index, this.newName);
}

class ReorderRoute extends RouteEvent {
  final int oldIndex;
  late final int newIndex;
  ReorderRoute(this.oldIndex, this.newIndex);
}

class SaveRoutes extends RouteEvent {}
