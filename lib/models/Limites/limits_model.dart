import 'dart:convert';

Limits limitsFromJson(String str) => Limits.fromJson(json.decode(str));
String limitsToJson(Limits data) => json.encode(data.toJson());

class Limits {
  Limits({
    required this.fijo,
    required this.corrido,
    required this.parle,
    required this.centena,
    required this.limitesmillonFijo,
    required this.limitesmillonCorrido,
  });

  int fijo;
  int corrido;
  int parle;
  int centena;
  int limitesmillonFijo;
  int limitesmillonCorrido;

  factory Limits.fromJson(Map<String, dynamic> json) => Limits(
    fijo: json['fijo'] ?? 0,
    corrido: json['corrido'] ?? 0,
    parle: json['parle'] ?? 0,
    centena: json['centena'] ?? 0,
    limitesmillonFijo: json['limitesMillonFijo'] ?? 0,
    limitesmillonCorrido: json['limitesMillonCorrido'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'fijo': fijo,
    'corrido': corrido,
    'parle': parle,
    'centena': centena,
    'limitesMillonFijo': limitesmillonFijo,
    'limitesMillonCorrido': limitesmillonCorrido,
  };
}
