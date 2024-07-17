import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart'; // Import rxdart
import 'package:valyutalar_kursi/data/models/currency.dart';
import 'package:valyutalar_kursi/data/repositories/currencies_repository.dart';

part 'currency_events.dart';
part 'currency_states.dart';

class CurrencyBloc extends Bloc<CurrencyEvents, CurrenciesStates> {
  CurrencyBloc(this.interfaceCurrencyRepository)
      : super(InitialCurrencyState()) {
    on<GetCurrencieEvent>(_getCurrencies);
    on<ConvertEvent>(_convert);
    on<SearchCurrencyEvent>(
      _searchCurrencies,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500)) // Use debounceTime
          .switchMap(mapper),
    );
  }

  final InterfaceCurrencyRepository interfaceCurrencyRepository;
  List<Currency> _currencies = [];

  void _getCurrencies(GetCurrencieEvent event, emit) async {
    emit(LoadingCurrencyState());
    try {
      _currencies = await interfaceCurrencyRepository.getCurrencies();
      emit(LoadedCurrencyState(_currencies));
    } catch (e) {
      emit(ErrorCurrencyState(e.toString()));
    }
  }

  void _convert(ConvertEvent event, emit) async {
    emit(LoadingCurrencyState());
    try {
      double convertedAmount = interfaceCurrencyRepository.convert(
        event.from,
        event.sum,
      );
      emit(ConvertedCurrencyState(convertedAmount, _currencies));
    } catch (e) {
      emit(ErrorCurrencyState(e.toString()));
    }
  }

  void _searchCurrencies(SearchCurrencyEvent event, emit) async {
    emit(LoadingCurrencyState());
    try {
      final query = event.query.toLowerCase();
      final filteredCurrencies = _currencies.where((currency) {
        final currencyName = currency.title.toLowerCase();
        return currencyName.contains(query);
      }).toList();
      emit(SearchedCurrencyState(filteredCurrencies));
    } catch (e) {
      emit(ErrorCurrencyState(e.toString()));
    }
  }
}
