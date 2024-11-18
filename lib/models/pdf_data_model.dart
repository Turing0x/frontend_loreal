import 'dart:convert';

PdfData pdfDataFromJson(String str) => PdfData.fromJson(json.decode(str));

String pdfDataToJson(PdfData data) => json.encode(data.toJson());

class PdfData {
  String id;
  String username;
  Role role;
  Payments payments;
  List<String> myPeople;
  Calcs calcs;
  String pdfDataId;

  PdfData({
    required this.id,
    required this.username,
    required this.role,
    required this.payments,
    required this.myPeople,
    required this.calcs,
    required this.pdfDataId,
  });

  factory PdfData.fromJson(Map<String, dynamic> json) => PdfData(
        id: json["_id"],
        username: json["username"],
        role: Role.fromJson(json["role"]),
        payments: Payments.fromJson(json["payments"]),
        myPeople: List<String>.from(json["myPeople"].map((x) => x)),
        calcs: Calcs.fromJson(json["calcs"]),
        pdfDataId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "role": role.toJson(),
        "payments": payments.toJson(),
        "myPeople": List<dynamic>.from(myPeople.map((x) => x)),
        "calcs": calcs.toJson(),
        "id": pdfDataId,
      };
}

class Calcs {
  int bruto;
  int limpio;
  int premio;
  int perdido;
  int ganado;

  Calcs({
    required this.bruto,
    required this.limpio,
    required this.premio,
    required this.perdido,
    required this.ganado,
  });

  factory Calcs.fromJson(Map<String, dynamic> json) => Calcs(
        bruto: int.parse(json["bruto"].round().toString()),
        limpio: int.parse(json["limpio"].round().toString()),
        premio: int.parse(json["premio"].round().toString()),
        perdido: int.parse(json["perdido"].round().toString()),
        ganado: int.parse(json["ganado"].round().toString()),
      );

  Map<String, dynamic> toJson() => {
        "bruto": bruto,
        "limpio": limpio,
        "premio": premio,
        "perdido": perdido,
        "ganado": ganado,
      };
}

class Role {
  String id;
  String name;
  String code;
  String roleId;

  Role({
    required this.id,
    required this.name,
    required this.code,
    required this.roleId,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["_id"],
        name: json["name"],
        code: json["code"],
        roleId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "code": code,
        "id": roleId,
      };
}

class Payments {
  int exprense;

  Payments({
    required this.exprense,
  });

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        exprense: json["exprense"],
      );

  Map<String, dynamic> toJson() => {
        "exprense": exprense,
      };
}
