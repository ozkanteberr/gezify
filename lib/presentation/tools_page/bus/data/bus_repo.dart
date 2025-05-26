import 'dart:convert';
import 'package:gezify/presentation/tools_page/bus/model/bus.dart';
import 'package:http/http.dart' as http;

class BusRepository {
  final String baseUrl = 'https://6834124c464b499636012cb4.mockapi.io/api/Bus';

  Future<List<Bus>> fetchBus() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Bus.fromJson(e)).toList();
    } else {
      throw Exception('Otobüs seferleri alınamadı');
    }
  }
}
