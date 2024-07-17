import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valyutalar_kursi/data/models/currency.dart';
import 'package:valyutalar_kursi/logic/blocs/currency/currency_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(GetCurrencieEvent());
    _searchController.addListener(
        _onSearchChanged); // Listen for changes in the search field
  }

  @override
  void dispose() {
    _searchController.dispose();
    sumController.dispose(); // Dispose sumController to avoid memory leaks
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<CurrencyBloc>().add(SearchCurrencyEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Valyutalar"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Valyutalarni izlash",
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CurrencyBloc, CurrenciesStates>(
        builder: (context, state) {
          if (state is LoadingCurrencyState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ErrorCurrencyState) {
            return Center(
              child: Text(state.message),
            );
          }

          List<Currency> currencies = [];
          if (state is LoadedCurrencyState) {
            currencies = state.currencies;
          } else if (state is ConvertedCurrencyState) {
            currencies = state.currencies;
          } else if (state is SearchedCurrencyState) {
            currencies = state.currencies;
          }

          return ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];

              return ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Form(
                        key: _formKey,
                        child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${currency.title}: "),
                                  Text("${currency.price} sum")
                                ],
                              ),
                              TextFormField(
                                controller: sumController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Miqdorni kiriting",
                                ),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "Summani kiriting";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<CurrencyBloc, CurrenciesStates>(
                                builder: (context, state) {
                                  if (state is ConvertedCurrencyState) {
                                    return Text(
                                      "${state.convertedAmount.toString()} sum",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Yopish"),
                            ),
                            FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<CurrencyBloc>().add(
                                        ConvertEvent(
                                          double.parse(currency.price),
                                          double.parse(sumController.text),
                                        ),
                                      );
                                }
                              },
                              child: const Text("Konvertatsiya"),
                            )
                          ],
                        ),
                      );
                    },
                  ).then((_) {
                    sumController.clear();
                  });
                },
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 14),
                ),
                title: Text(currency.title),
                trailing: Text("${currency.price} sum"),
              );
            },
          );
        },
      ),
    );
  }
}
