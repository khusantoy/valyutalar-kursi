import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valyutalar_kursi/logic/blocs/currency/currency_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(GetCurrencieEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Valyutalar"),
      ),
      body: BlocBuilder<CurrencyBloc, CurrenciesStates>(
        builder: (context, state) {
          print(state);
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

          if (state is LoadedCurrencyState || state is ConvertedCurrencyState) {
            final currencies = (state is LoadedCurrencyState)
                ? state.currencies
                : (state as ConvertedCurrencyState).currencies;

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
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
