import 'dart:convert';
import 'package:gezify/presentation/tools_page/flight/model/flight.dart';
import 'package:http/http.dart' as http;

class FlightRepository {
  final String baseUrl =
      'https://68337b69464b499636ff9a68.mockapi.io/api/flights';

  Future<List<Flight>> fetchFlights() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Flight.fromJson(e)).toList();
    } else {
      throw Exception('Uçuşlar alınamadı');
    }
  }
}
