import 'dart:convert';

BolaCargadaModel bolaCargadaModelFromJson(String str) => BolaCargadaModel.fromJson(json.decode(str));
String bolaCargadaModelToJson(BolaCargadaModel data) => json.encode(data.toJson());

class BolaCargadaModel {
  final String numero;
  final int fijo;
  final List<Listero> listeros;

  BolaCargadaModel({
    required this.numero,
    required this.fijo,
    required this.listeros,
  });

  factory BolaCargadaModel.fromJson(Map<String, dynamic> json) => BolaCargadaModel(
    numero: json["numero"],
    fijo: json["fijo"],
    listeros: List<Listero>.from(json["listeros"].map((x) => Listero.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "numero": numero,
    "fijo": fijo,
    "listeros": List<dynamic>.from(listeros.map((x) => x.toJson())),
  };
}

class Listero {
  final String username;
  final int fijo;
  final List<Separado> separados;

  Listero({
    required this.username,
    required this.fijo,
    required this.separados,
  });

  factory Listero.fromJson(Map<String, dynamic> json) => Listero(
    username: json["username"],
    fijo: json["fijo"],
    separados: List<Separado>.from(json["separados"].map((x) => Separado.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "fijo": fijo,
    "separados": List<dynamic>.from(separados.map((x) => x.toJson())),
  };
}

class Separado {
  final int fijo;

  Separado({
    required this.fijo,
  });

  factory Separado.fromJson(Map<String, dynamic> json) => Separado(
    fijo: json["fijo"],
  );

  Map<String, dynamic> toJson() => {
    "fijo": fijo,
  };
}
