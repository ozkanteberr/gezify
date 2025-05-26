class Flight {
  final String id;
  final String airline;
  final String departure;
  final String arrival;
  final String departureTime;
  final String arrivalTime;
  final double price;

  Flight({
    required this.id,
    required this.airline,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      airline: json['airline'],
      departure: json['departure'],
      arrival: json['arrival'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      price: double.parse(json['price'].toString()),
    );
  }
}
