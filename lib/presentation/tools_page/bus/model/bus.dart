class Bus {
  final String id;
  final String busCompany;
  final String departure;
  final String arrival;
  final String departureTime;
  final String arrivalTime;
  final double price;

  Bus({
    required this.id,
    required this.busCompany,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      busCompany: json['busCompany'],
      departure: json['departure'],
      arrival: json['arrival'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      price: double.parse(json['price'].toString()),
    );
  }
}
