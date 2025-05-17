class RotaListesi {
  final String listName;
  final List<String> routes;

  RotaListesi({required this.listName, required this.routes});

  Map<String, dynamic> toJson() => {
        'listName': listName,
        'routes': routes,
      };

  factory RotaListesi.fromJson(Map<String, dynamic> json) {
    return RotaListesi(
      listName: json['listName'] ?? '',
      routes: List<String>.from(json['routes'] ?? []),
    );
  }
}
