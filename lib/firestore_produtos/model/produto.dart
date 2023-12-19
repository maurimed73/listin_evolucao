class Produto {
  String id;
  String name;
  double? price;
  double? amount;
  bool isComprado;

  Produto({
    required this.id,
    required this.name,
    required this.isComprado,
    this.price,
    this.amount,
  });

  Produto.fromMap(Map<String, dynamic> map) // vem da internet
      : id = map["id"],
        name = map["name"],
        isComprado = map["isComprado"],
        price = map["price"],
        amount = map["amount"];

  Map<String, dynamic> toMap() {
    // vai para a internet
    return {
      "id": id,
      "name": name,
      "isComprado": isComprado,
      "price": price,
      "amount": amount,
    };
  }
}
