import 'dart:convert';

CollectionDebtModel collectionDebtModelFromJson(String str) => CollectionDebtModel.fromJson(json.decode(str));

String collectionDebtModelToJson(CollectionDebtModel data) => json.encode(data.toJson());

class CollectionDebtModel {
  String id;
  String name;
  String debt;
  String percent;

  CollectionDebtModel({
    required this.id,
    required this.name,
    required this.debt,
    required this.percent,
  });

  factory CollectionDebtModel.fromJson(Map<String, dynamic> json) => CollectionDebtModel(
    id: json["id"],
    name: json["name"],
    debt: json["debt"],
    percent: json["percent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "debt": debt,
    "percent": percent,
  };
}