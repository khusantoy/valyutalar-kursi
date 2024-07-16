import 'dart:convert';

import 'package:valyutalar_kursi/data/models/currency.dart';
import 'package:http/http.dart' as http;

class CurrencyHttpService {
  Future<List<Currency>> getCurrencies() async {
    Uri url = Uri.parse("https://cbu.uz/uz/arkhiv-kursov-valyut/json/");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Currency> currencies =
            data.map((currency) => Currency.fromJson(currency)).toList();

        return currencies;
      } else {
        throw Exception("Failed to load currencies");
      }
    } catch (e) {
      print("Xatolik: $e");
      return [];
    }
  }
}
