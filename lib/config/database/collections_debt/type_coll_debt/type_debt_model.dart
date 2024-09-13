import 'dart:convert';

TypeDebtModel typeDebtModelFromJson(String str) =>
    TypeDebtModel.fromJson(json.decode(str));

String typeDebtModelToJson(TypeDebtModel data) => json.encode(data.toJson());

class TypeDebtModel {
  String id;
  String owner;
  String limpio;
  String premio;
  String pierde;
  String gana;
  String jornal;
  String date;

  TypeDebtModel({
    required this.id,
    required this.owner,
    required this.limpio,
    required this.premio,
    required this.pierde,
    required this.gana,
    required this.jornal,
    required this.date,
  });

  factory TypeDebtModel.fromJson(Map<String, dynamic> json) => TypeDebtModel(
        id: json["id"],
        owner: json["owner"],
        limpio: json["limpio"],
        premio: json["premio"],
        pierde: json["pierde"],
        gana: json["gana"],
        jornal: json["jornal"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "limpio": limpio,
        "premio": premio,
        "pierde": pierde,
        "gana": gana,
        "jornal": jornal,
        "date": date,
      };
}
