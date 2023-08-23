import 'dart:convert';

BoliList? boliListFromJson(String str) => BoliList.fromJson(json.decode(str));

String boliListToJson(BoliList? data) => json.encode(data!.toJson());

class BoliList {
  BoliList({
    this.id,
    this.owner,
    this.jornal,
    this.date,
    this.signature,
    this.calcs,
  });

  String? id;
  Object? owner;
  String? jornal;
  String? date;
  String? signature;
  Object? calcs;

  factory BoliList.fromJson(Map<String, dynamic> json) => BoliList(
        id: (json.containsKey('_id'))
            ? json['_id']
            : (json.containsKey('id'))
                ? json['id']
                : '',
        owner: json['owner'],
        jornal: json['jornal'],
        date: json['date'],
        signature: json['signature'] ?? '',
        calcs: json['calcs'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'owner': owner,
        'jornal': jornal,
        'date': date,
        'signature': signature,
        'calcs': calcs,
      };
}
