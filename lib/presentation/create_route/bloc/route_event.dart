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
  final int newIndex;
  ReorderRoute(this.oldIndex, this.newIndex);
}

class TogglePrivacy extends RouteEvent {
  final bool isPrivate;
  TogglePrivacy(this.isPrivate);
}

class SaveRoutesToFirebase extends RouteEvent {
  final String uid;
  final String listTitle;
  final bool isPrivate;

  SaveRoutesToFirebase({
    required this.uid,
    required this.listTitle,
    required this.isPrivate,
  });
}

class ClearRoutes extends RouteEvent {}
