import 'package:valyutalar_kursi/data/models/currency.dart';
import 'package:valyutalar_kursi/services/currency_http_service.dart';

abstract class InterfaceCurrencyRepository {
  Future<List<Currency>> getCurrencies();
  double convert(double from, double sum);
}

class CurrenciesRepository implements InterfaceCurrencyRepository {
  final CurrencyHttpService currencyHttpService;

  CurrenciesRepository(this.currencyHttpService);

  @override
  Future<List<Currency>> getCurrencies() async {
    return await currencyHttpService.getCurrencies();
  }

  @override
  double convert(double from, double sum) {
    print(from * sum);
    return (from * sum);
  }
}
