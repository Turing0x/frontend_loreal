import 'dart:convert';

Sorteo? lotFromJson(String str) => Sorteo.fromJson(json.decode(str));

String lotToJson(Sorteo? data) => json.encode(data!.toJson());

class Sorteo {
  Sorteo({
    required this.id,
    required this.lot,
    required this.jornal,
    required this.date,
  });

  String id;
  String lot;
  String jornal;
  String date;

  factory Sorteo.fromJson(Map<String, dynamic> json) => Sorteo(
    id: json['_id'],
    lot: json['lot'],
    jornal: json['jornal'],
    date: json['date'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'lot': lot,
    'jornal': jornal,
    'date': date,
  };
}
