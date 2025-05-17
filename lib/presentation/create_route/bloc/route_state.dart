class RouteState {
  final List<String> routes;
  final bool isPrivate;

  RouteState(this.routes, {this.isPrivate = true});

  RouteState copyWith({List<String>? routes, bool? isPrivate}) {
    return RouteState(
      routes ?? this.routes,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
