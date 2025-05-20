class RotaListesi {
  final String listName;
  final String id;
  final List<String> routes;
  final bool isPrivate;
  final String title;

  RotaListesi(
      {required this.listName,
      required this.id,
      required this.routes,
      required this.isPrivate,
      required this.title});

  Map<String, dynamic> toJson() => {
        'listName': listName,
        'routes': routes,
        'isPrivate': isPrivate,
        'title': title,
        'id': id
      };

  factory RotaListesi.fromJson(Map<String, dynamic> json) {
    return RotaListesi(
      listName: json['listName'] ?? '',
      routes: List<String>.from(json['routes'] ?? []),
      isPrivate: json['isPrivate'] ?? true,
      title: json['title'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
