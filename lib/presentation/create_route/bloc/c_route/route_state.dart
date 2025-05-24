import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteState {
  final List<Destination> routes;
  final bool isPrivate;
  final List<LatLng> polylineCoordinates;

  RouteState(
    this.routes, {
    this.isPrivate = true,
    this.polylineCoordinates = const [],
  });

  RouteState copyWith({
    List<Destination>? routes,
    bool? isPrivate,
    List<LatLng>? polylineCoordinates,
  }) {
    return RouteState(
      routes ?? this.routes,
      isPrivate: isPrivate ?? this.isPrivate,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
    );
  }
}
