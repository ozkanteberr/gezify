// import 'dart:convert';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';
// import 'package:googleapis_auth/auth_io.dart';

// class CalendarService {
//   static final _scopes = [calendar.CalendarApi.calendarScope];

//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: _scopes,
//   );

//   GoogleSignInAccount? _currentUser;

//   Future<calendar.CalendarApi?> getCalendarApi() async {
//     _currentUser = await _googleSignIn.signIn();

//     if (_currentUser == null) {
//       print('Google hesabıyla giriş yapılmadı.');
//       return null;
//     }

//     final authHeaders = await _currentUser!.authHeaders;
//     final httpClient = GoogleHttpClient(authHeaders);

//     return calendar.CalendarApi(httpClient);
//   }

//   Future<void> addEvent({
//     required String summary,
//     required DateTime startTime,
//     required DateTime endTime,
//   }) async {
//     final calendarApi = await getCalendarApi();
//     if (calendarApi == null) return;

//     final event = calendar.Event()
//       ..summary = summary
//       ..start = calendar.EventDateTime(
//         dateTime: startTime,
//         timeZone: "GMT+03:00",
//       )
//       ..end = calendar.EventDateTime(
//         dateTime: endTime,
//         timeZone: "GMT+03:00",
//       );

//     await calendarApi.events.insert(event, "primary");
//     print("Etkinlik başarıyla oluşturuldu.");
//   }
// }

// /// GoogleHttpClient sınıfı, kimlik doğrulama başlıklarını iletmek için:
// class GoogleHttpClient extends http.BaseClient {
//   final Map<String, String> _headers;
//   final http.Client _client = http.Client();

//   GoogleHttpClient(this._headers);

//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return _client.send(request..headers.addAll(_headers));
//   }

//   @override
//   void close() {
//     _client.close();
//   }
// }
