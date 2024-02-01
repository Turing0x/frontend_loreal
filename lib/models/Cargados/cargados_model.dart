import 'dart:convert';

BolaCargadaModel bolaCargadaModelFromJson(String str) => BolaCargadaModel.fromJson(json.decode(str));

String bolaCargadaModelToJson(BolaCargadaModel data) => json.encode(data.toJson());

class BolaCargadaModel {
  String? jugada;
  int? dinero;
  
  final String numero;
  final int total;
  final int fijo;
  final int? totalCorrido;
  final int? corrido;
  final List<Listero> listeros;

  BolaCargadaModel({
    required this.numero,
    required this.total,
    required this.fijo,
    required this.totalCorrido,
    required this.corrido,
    required this.dinero,
    required this.jugada,
    required this.listeros,
  });

  factory BolaCargadaModel.fromJson(Map<String, dynamic> json) => BolaCargadaModel(
    numero: json["numero"],
    total: json["total"],
    fijo: json["fijo"],
    totalCorrido: json["totalCorrido"],
    corrido: json["corrido"],
    dinero: json["dinero"],
    jugada: json["jugada"],
    listeros: List<Listero>.from(json["listeros"].map((x) => Listero.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "numero": numero,
    "total": total,
    "fijo": fijo,
    "totalCorrido": totalCorrido,
    "corrido": corrido,
    "dinero": dinero,
    "jugada": jugada,
    "listeros": List<dynamic>.from(listeros.map((x) => x.toJson())),
  };
}

class Listero {
  final String username;
  final int fijo;
  final int? totalCorrido;
  final int? corrido;
  final int total;
  final List<Separado> separados;

  Listero({
    required this.username,
    required this.fijo,
    required this.totalCorrido,
    required this.corrido,
    required this.total,
    required this.separados,
  });

  factory Listero.fromJson(Map<String, dynamic> json) => Listero(
    username: json["username"],
    fijo: json["fijo"],
    totalCorrido: json["totalCorrido"],
    corrido: json["corrido"],
    total: json["total"],
    separados: List<Separado>.from(json["separados"].map((x) => Separado.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "fijo": fijo,
    "totalCorrido": totalCorrido,
    "corrido": corrido,
    "total": total,
    "separados": List<dynamic>.from(separados.map((x) => x.toJson())),
  };
}

class Separado {
  final int fijo;
  final int? corrido;

  Separado({
    required this.fijo,
    required this.corrido,
  });

  factory Separado.fromJson(Map<String, dynamic> json) => Separado(
    fijo: json["fijo"],
    corrido: json["corrido"],
  );

  Map<String, dynamic> toJson() => {
    "fijo": fijo,
    "corrido": corrido,
  };
}
