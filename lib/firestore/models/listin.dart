class Listin {
  String id;
  String name;

  Listin({required this.id, required this.name});

  Listin.fromMap(Map<String, dynamic> map) // do firestore (map) para o modelo
      : id = map["id"],
        name = map["name"];

  Map<String, dynamic> toMap() {   // do modelo para firestore (map)
    return {
      "id": id,
      "name": name,
    };
  }
}
