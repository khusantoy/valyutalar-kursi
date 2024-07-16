import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valyutalar_kursi/core/app.dart';
import 'package:valyutalar_kursi/data/repositories/currencies_repository.dart';
import 'package:valyutalar_kursi/logic/blocs/currency/currency_bloc.dart';
import 'package:valyutalar_kursi/services/currency_http_service.dart';

void main() {
  final currencyHttpService = CurrencyHttpService();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) {
          return CurrenciesRepository(currencyHttpService);
        })
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CurrencyBloc(
              CurrenciesRepository(CurrencyHttpService()),
            ),
          )
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}
