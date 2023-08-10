// To parse this JSON data, do
//
//     final collectionDebtModel = collectionDebtModelFromJson(jsonString);

import 'dart:convert';

CollectionDebtModel collectionDebtModelFromJson(String str) => CollectionDebtModel.fromJson(json.decode(str));

String collectionDebtModelToJson(CollectionDebtModel data) => json.encode(data.toJson());

class CollectionDebtModel {
    String id;
    String name;
    String debt;
    List<ListDebt> listDebt;

    CollectionDebtModel({
        required this.id,
        required this.name,
        required this.debt,
        required this.listDebt,
    });

    factory CollectionDebtModel.fromJson(Map<String, dynamic> json) => CollectionDebtModel(
        id: json["id"],
        name: json["name"],
        debt: json["debt"],
        listDebt: List<ListDebt>.from(json["listDebt"].map((x) => ListDebt.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "debt": debt,
        "listDebt": List<dynamic>.from(listDebt.map((x) => x.toJson())),
    };
}

class ListDebt {
    String typeDebt;
    String debt;
    String jornal;
    String date;

    ListDebt({
        required this.typeDebt,
        required this.debt,
        required this.jornal,
        required this.date,
    });

    factory ListDebt.fromJson(Map<String, dynamic> json) => ListDebt(
        typeDebt: json["typeDebt"],
        debt: json["debt"],
        jornal: json["jornal"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "typeDebt": typeDebt,
        "debt": debt,
        "jornal": jornal,
        "date": date,
    };
}
