class RouteList {
  final String id;
  final String title;
  final bool isPrivate;
  final List<dynamic> routes;

  RouteList({
    required this.id,
    required this.title,
    required this.isPrivate,
    required this.routes,
  });

  factory RouteList.fromMap(Map<String, dynamic> data) {
    return RouteList(
      id: data['routeId'] ?? '',
      title: data['title'] ?? '',
      isPrivate: data['isPrivate'] ?? false,
      routes: data['routes'] ?? [],
    );
  }
}
