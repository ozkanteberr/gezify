import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyBqw_tHrdjJe4GkgBTS3GWLX0vVA1Zz1aY'; // Kendi key'inizi buraya koyun
  final String apiUrl =
  'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';


  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': userMessage}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final candidates = data['candidates'];
        if (candidates != null &&
            candidates.isNotEmpty &&
            candidates[0]['content'] != null &&
            candidates[0]['content']['parts'] != null &&
            candidates[0]['content']['parts'].isNotEmpty) {
          final text = candidates[0]['content']['parts'][0]['text'];
          return text ?? 'Boş cevap alındı.';
        } else {
          print('Cevap yapısı beklenenden farklı: ${response.body}');
          return 'Boş cevap alındı.';
        }
      } else {
        print('HTTP hata: ${response.statusCode} - ${response.body}');
        return 'Sunucu hatası: ${response.statusCode}';
      }
    } catch (e) {
      print('İstek hatası: $e');
      return 'Bir hata oluştu: $e';
    }
  }
}
