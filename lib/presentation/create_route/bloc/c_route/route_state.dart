import 'package:gezify/presentation/home/domain/entities/destination.dart';

class RouteState {
  final List<Destination> routes;
  final bool isPrivate;

  RouteState(this.routes, {this.isPrivate = true});

  RouteState copyWith({List<Destination>? routes, bool? isPrivate}) {
    return RouteState(
      routes ?? this.routes,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
