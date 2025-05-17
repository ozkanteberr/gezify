abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final Map<String, double> rates;

  CurrencyLoaded(this.rates);
}

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);
}