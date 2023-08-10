import 'dart:convert';

TypeDebtModel typeDebtModelFromJson(String str) => TypeDebtModel.fromJson(json.decode(str));

String typeDebtModelToJson(TypeDebtModel data) => json.encode(data.toJson());

class TypeDebtModel {
  String id;
  String owner;
  String typeDebt;
  String debt;
  String jornal;
  String date;

  TypeDebtModel({
    required this.id,
    required this.owner,
    required this.typeDebt,
    required this.debt,
    required this.jornal,
    required this.date,
  });

  factory TypeDebtModel.fromJson(Map<String, dynamic> json) => TypeDebtModel(
    id: json["id"],
    owner: json["owner"],
    typeDebt: json["typeDebt"],
    debt: json["debt"],
    jornal: json["jornal"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner": owner,
    "typeDebt": typeDebt,
    "debt": debt,
    "jornal": jornal,
    "date": date,
  };
}
