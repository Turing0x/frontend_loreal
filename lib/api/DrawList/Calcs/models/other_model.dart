import 'dart:convert';

CalcsOfList calcsOfListFromJson(String str) => CalcsOfList.fromJson(json.decode(str));

String calcsOfListToJson(CalcsOfList data) => json.encode(data.toJson());

class CalcsOfList {
  CalcsOfList({
    required this.bruto,
    required this.limpio,
    required this.premio,
    required this.perdido,
    required this.ganado,
  });

  final int bruto;
  final int limpio;
  final int premio;
  final int perdido;
  final int ganado;

  factory CalcsOfList.fromJson(Map<String, dynamic> json) => CalcsOfList(
    bruto: json['bruto'],
    limpio: json['limpio'],
    premio: json['premio'],
    perdido: json['perdido'],
    ganado: json['ganado'],
  );

  Map<String, dynamic> toJson() => {
    'bruto': bruto,
    'limpio': limpio,
    'premio': premio,
    'perdido': perdido,
    'ganado': ganado,
  };
}
