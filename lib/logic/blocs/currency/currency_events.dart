part of 'currency_bloc.dart';

sealed class CurrencyEvents {}

final class GetCurrencieEvent extends CurrencyEvents {}

class ConvertEvent extends CurrencyEvents {
  final double from;
  final double sum;

  ConvertEvent(this.from, this.sum);
}

class SearchCurrencyEvent extends CurrencyEvents {
  final String query;

  SearchCurrencyEvent(this.query);
}
