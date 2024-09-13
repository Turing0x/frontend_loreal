import 'dart:convert';

CollectionDebtModel collectionDebtModelFromJson(String str) =>
    CollectionDebtModel.fromJson(json.decode(str));

String collectionDebtModelToJson(CollectionDebtModel data) =>
    json.encode(data.toJson());

class CollectionDebtModel {
  String id;
  String name;

  CollectionDebtModel({
    required this.id,
    required this.name,
  });

  factory CollectionDebtModel.fromJson(Map<String, dynamic> json) =>
      CollectionDebtModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
