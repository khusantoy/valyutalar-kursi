part of 'currency_bloc.dart';

abstract class CurrenciesStates {}

class InitialCurrencyState extends CurrenciesStates {}

class LoadingCurrencyState extends CurrenciesStates {}

class LoadedCurrencyState extends CurrenciesStates {
  final List<Currency> currencies;

  LoadedCurrencyState(this.currencies);
}

class ErrorCurrencyState extends CurrenciesStates {
  final String message;

  ErrorCurrencyState(this.message);
}

class ConvertedCurrencyState extends CurrenciesStates {
  final double convertedAmount;
  final List<Currency> currencies;

  ConvertedCurrencyState(this.convertedAmount, this.currencies);
}

class SearchedCurrencyState extends CurrenciesStates {
  final List<Currency> currencies;

  SearchedCurrencyState(this.currencies);
}
