class Currency {
  String title;
  String price;

  String date;

  Currency({
    required this.title,
    required this.price,
    required this.date,
  });

  factory Currency.fromJson(Map<String, dynamic> currency) {
    return Currency(
      title: currency['CcyNm_UZ'],
      price: currency['Rate'],
      date: currency['Date'],
    );
  }
}
