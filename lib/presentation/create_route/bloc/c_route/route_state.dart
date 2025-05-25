import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteState {
  final List<Destination> routes;
  final bool isPrivate;
  final List<LatLng> polylineCoordinates;
  final String? totalDistance;
  final String? totalDuration;

  RouteState(
    this.routes, {
    this.isPrivate = true,
    this.polylineCoordinates = const [],
    this.totalDistance,
    this.totalDuration,
  });

  RouteState copyWith({
    List<Destination>? routes,
    bool? isPrivate,
    List<LatLng>? polylineCoordinates,
    String? totalDistance,
    String? totalDuration,
  }) {
    return RouteState(
      routes ?? this.routes,
      isPrivate: isPrivate ?? this.isPrivate,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      totalDistance: totalDistance ?? this.totalDistance,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}
