import 'dart:convert';

OfflineList? boliListFromJson(String str) => OfflineList.fromJson(json.decode(str));

String boliListToJson(OfflineList? data) => json.encode(data!.toJson());

class OfflineList {
  OfflineList({
    this.id,
    this.owner,
    this.jornal,
    this.date,
    this.signature,
    this.bruto,
    this.limpio,
  });

  String? id;
  Object? owner;
  String? jornal;
  String? date;
  String? signature;
  String? bruto;
  String? limpio;

  factory OfflineList.fromJson(Map<String, dynamic> json) => OfflineList(
    id: ( json.containsKey( 'id' ) ) ? json['id'] : '',
    owner: json['owner'],
    jornal: json['jornal'],
    date: json['date'],
    signature: json['signature'],
    bruto: json['bruto'],
    limpio: json['limpio'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner': owner,
    'jornal': jornal,
    'date': date,
    'signature': signature,
    'bruto': bruto,
    'limpio': limpio,
  };
}
