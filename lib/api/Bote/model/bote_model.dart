import 'dart:convert';

BoteModel boteModelFromJson(String str) => BoteModel.fromJson(json.decode(str));

String boteModelToJson(BoteModel data) => json.encode(data.toJson());

class BoteModel {
    BoteModel({
        required this.bruto,
        required this.botado,
    });

    final int bruto;
    final List<Botado> botado;

    factory BoteModel.fromJson(Map<String, dynamic> json) => BoteModel(
        bruto: json["bruto"],
        botado: List<Botado>.from(json["botado"].map((x) => Botado.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "bruto": bruto,
        "botado": List<dynamic>.from(botado.map((x) => x.toJson())),
    };
}

class Botado {
    Botado({
        required this.numero,
        required this.botado,
    });

    final List<dynamic> numero;
    final int botado;

    factory Botado.fromJson(Map<String, dynamic> json) => Botado(
        numero: List<dynamic>.from(json["numero"].map((x) => x)),
        botado: json["botado"],
    );

    Map<String, dynamic> toJson() => {
        "numero": List<dynamic>.from(numero.map((x) => x)),
        "botado": botado,
    };
}
