import 'dart:convert';

SignatureModel signatureModelFromJson(String str) => SignatureModel.fromJson(json.decode(str));

String signatureModelToJson(SignatureModel data) => json.encode(data.toJson());

class SignatureModel {
  String id;
  String signature;
  String jornal;
  String date;

  SignatureModel({
    required this.id,
    required this.signature,
    required this.jornal,
    required this.date,
  });

  factory SignatureModel.fromJson(Map<String, dynamic> json) => SignatureModel(
    id: json["_id"] ?? '',
    signature: json["signature"] ?? '',
    jornal: json["jornal"] ?? '',
    date: json["date"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "signature": signature,
    "jornal": jornal,
    "date": date,
  };
}
