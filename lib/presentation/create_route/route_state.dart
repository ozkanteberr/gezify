class RouteState {
  final List<String> routes;

  RouteState(this.routes);

  RouteState copyWith({List<String>? routes}) {
    return RouteState(routes ?? this.routes);
  }
}
