import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitial()) {
    on<FetchCurrencyRates>(_onFetchCurrencyRates);
  }

  Future<void> _onFetchCurrencyRates(
    FetchCurrencyRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());

    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        double usdToTry = data['rates']['TRY'];
        double eurToTry = usdToTry / data['rates']['EUR'];

        Map<String, double> rates = {
          'USD': usdToTry,
          'EUR': eurToTry,
        };

        emit(CurrencyLoaded(rates));
      } else {
        emit(
            CurrencyError('Veri alınamadı. Hata kodu: ${response.statusCode}'));
      }
    } catch (e) {
      emit(CurrencyError('Veri alınırken bir hata oluştu: $e'));
    }
  }
}
