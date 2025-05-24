import 'package:gezify/presentation/home/domain/entities/destination.dart';

abstract class RouteEvent {}

class AddDestinationToRoute extends RouteEvent {
  final Destination destination;
  AddDestinationToRoute(this.destination);
}

class RemoveDestinationFromRoute extends RouteEvent {
  final int index;
  RemoveDestinationFromRoute(this.index);
}

class TogglePrivacy extends RouteEvent {
  final bool isPrivate;
  TogglePrivacy(this.isPrivate);
}

class SaveDestinationsToFirebase extends RouteEvent {
  final String uid;
  final String listTitle;

  SaveDestinationsToFirebase({
    required this.uid,
    required this.listTitle,
  });
}

class LoadRouteOnMap extends RouteEvent {
  final List<Map<String, dynamic>> routeData;

  LoadRouteOnMap(this.routeData);
}

class LoadRouteWithCurrentLocation extends RouteEvent {
  final List<Map<String, dynamic>> routePoints;

  LoadRouteWithCurrentLocation(this.routePoints);
}

class ClearDestinations extends RouteEvent {}
